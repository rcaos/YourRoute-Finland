//
//  MainViewController.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var closeView: CloseView!
    @IBOutlet weak var resultListView: ResultListView!
    @IBOutlet weak var resultRouteView: ResultRouteView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var errorView: ErrorView!
    
    private var genericMapView: UIView?
    
    private var dataSource: ResultListViewDataSource!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupDelegates()
    }
    
    func setupViewModel() {
        setupModels()
        setupBindables()
        setupMapView()
        
        viewModel?.viewState.value = .initial
    }
    
    //MARK: - only for Test
    
    func setupTestShowRoute() {
        let testItinerarie = MakeData.makeItinerariePoints()
        viewModel?.mapViewModel = MainMapViewModel(itinerarie: testItinerarie)
        viewModel?.viewState.value = .populated
    }
    
    func setupTestDetailItinerarie() {
        let itineraries = MakeData.makeItinerarieDetail()
        resultRouteView.viewModel = ResultRouteViewModel(itineraries: itineraries)
        
        viewModel?.viewState.value = .populated
    }
    //END:  Only for Tests
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        searchView.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0.58, alpha: 0)
    }
    
    func setupTableView() {
        let tableView = resultListView.tableView
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func setupDelegates() {
        searchView.delegate = self
        resultRouteView.delegate = self
        closeView.delegate = self
    }
    
    func setupMapView() {
        guard let typeMap = viewModel?.searchViewModel.dataSource.typeSource else { return }
        
        switch typeMap {
        case .apple:
            let mapKitView = MapKitView(frame: mapView.frame)
            genericMapView = mapKitView
           
        case .google:
            let googleMapView = GoogleMapView(frame: mapView.frame)
            genericMapView = googleMapView
        }
        
        guard let genericView = genericMapView else { return }
        
        genericView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview( genericView )
        NSLayoutConstraint.activate([genericView.topAnchor.constraint(equalTo: mapView.topAnchor),
                                     genericView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
                                     genericView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
                                     genericView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor)])
    }
    
    func setupModels() {
        guard let viewModel = viewModel else { return }
        searchView.viewModel = viewModel.searchViewModel
    }
    
    func setupBindables() {
        viewModel?.reloadTable = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configTableView()
        }
        
        viewModel?.showResultRoute = { [weak self] resultRouteViewModel in
            guard let strongSelf = self else { return }
            
            strongSelf.configResultView(witth: resultRouteViewModel)
        }
        
        viewModel?.viewState.bind({ [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.configView(with: state)
        })
    }
    
    func configResultView(witth viewModel: ResultRouteViewModel?) {
        guard let resultRouteViewModel = viewModel else { return }
        resultRouteView.viewModel = resultRouteViewModel
        resultRouteView.viewModel?.checkFirstItinerarie()
    }
    
    func configMap(with model: MainMapViewModel?) {
        guard let mapViewModel = model else { return }
        
        self.viewModel?.mapViewModel = mapViewModel
        
        setViewModeltoMap()
        
        self.viewModel?.mapViewModel?.showRoute()
    }
    
    func configTableView() {
        guard let resultListModel = viewModel?.resultListViewModel else { return }
        dataSource = ResultListViewDataSource(viewModel: resultListModel)
        
        resultListView.tableView.dataSource = dataSource
        resultListView.tableView.delegate = self
        resultListView.tableView.reloadData()
        resultListView.isHidden = false
    }
    
    func configView(with state: MainViewModel.ViewState) {
        searchView.isUserInteractionEnabled = true
        
        searchView.isHidden = true
        closeView.isHidden = true
        resultListView.isHidden = true
        resultRouteView.isHidden = true
        loadingView.isHidden = true
        errorView.isHidden = true
        
        setViewModeltoMap()
        
        switch state {
        case .initial:
            searchView.isHidden = false
            print("Change view to .initial")
        case .loading:
            searchView.isHidden = false
            searchView.isUserInteractionEnabled = false
            loadingView.isHidden = false
            print("Change view to .loading")
        case .populated:
            closeView.isHidden = false
            resultRouteView.isHidden = false
            print("Change view to populated")
        case .error:
            searchView.isHidden = false
            errorView.isHidden = false
            print("Change view to .error")
        }
    }
    
    // MARK: - TODO Refactor this
    
    private func setViewModeltoMap() {
        guard let type = viewModel?.searchViewModel.dataSource.typeSource else { return }
        
        switch type {
        case .apple:
            if let mapView = genericMapView as? MapKitView {
                mapView.viewModel = self.viewModel?.getMapViewModel()
            }
        case .google:
            if let mapView = genericMapView as? GoogleMapView {
                mapView.viewModel = self.viewModel?.getMapViewModel()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailRouteSegue" {
            if let navigation = segue.destination as? UINavigationController,
                let destination  = navigation.topViewController as? DetailRouteViewController {
                destination.viewModel = sender as? DetailRouteViewModel
            }
        }
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectedResultListPlace(at: indexPath)
        resultListView.isHidden = true
    }
}

//MARK: - SearchViewDelegate

extension MainViewController: SearchViewDelegate {
    
    func searchViewDelegate(_ searchView: SearchView, didChangeSource source: ResultListViewModel) {
        viewModel?.configResultListModel(with: source)
    }
    
    func searchViewDelegate(_ searchView: SearchView, planningTrip searchModel: SearchViewModel?) {
        guard let searchModel = searchModel else { return }
        viewModel?.planningTrip(with: searchModel)
    }
    
    func searchViewDelegateDidEndResults(_ searchView: SearchView) {
        resultListView.isHidden = true
        self.view.endEditing(true)
    }
}

//MARK: - ResultRouteViewDelegate

extension MainViewController: ResultRouteViewDelegate {
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didSelectRouteDetail detail: DetailRouteViewModel) {
        performSegue(withIdentifier: "DetailRouteSegue", sender: detail)
    }
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didChangeItinerarie mapViewModel: MainMapViewModel) {
        configMap(with: mapViewModel)
    }
}

//MARK: - CloseViewDelegate

extension MainViewController: CloseViewDelegate {
    
    func closeViewDelegateDidClose(_ searchView: CloseView) {
        viewModel?.viewState.value = .initial
    }
}
