//
//  MainViewController.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    @IBOutlet weak var mapView: MainMapView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var closeView: CloseView!
    @IBOutlet weak var resultListView: ResultListView!
    @IBOutlet weak var resultRouteView: ResultRouteView!
    
    private var dataSource: ResultListViewDataSource!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupModels()
        setupTableView()
        setupBindables()
        
        configView(with: .initial)
        
        //ONly for Test
        //setupTestDetailItinerarie()
        //setupTestShowRoute()
    }
    
    //MARK: - only for Test
    
    func setupTestShowRoute() {
        let testItinerarie = MakeData.makeItinerariePoints()
        let mapViewModel = MainMapViewModel(itinerarie: testItinerarie)
        mapView.viewModel = mapViewModel
        mapViewModel.showRoute()
        
        searchView.isHidden = true
    }
    
    func setupTestDetailItinerarie() {
        let itineraries = MakeData.makeItinerarieDetail()
        resultRouteView.viewModel = ResultRouteViewModel(itineraries: itineraries)
        
        configView(with: .populated)
    }
    //END:  Only for Tests
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        //why??
        searchView.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0.58, alpha: 0)
    }
    
    func setupModels() {
        searchView.viewModel = viewModel.searchViewModel
        
        searchView.delegate = self
        resultRouteView.delegate = self
        closeView.delegate = self
    }
    
    func setupTableView() {
        let tableView = resultListView.tableView
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func setupBindables() {
        viewModel.reloadTable = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configTableView()
        }
        
        viewModel.showResultRoute = { [weak self] resultRouteViewModel in
            guard let strongSelf = self else { return }
            
            strongSelf.configResultView(witth: resultRouteViewModel)
        }
        
        viewModel.viewState.bind({ [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.configView(with: state)
        })
    }
    
    func configResultView(witth viewModel: ResultRouteViewModel?) {
        guard let resultRouteViewModel = viewModel else { return }
        resultRouteView.viewModel = resultRouteViewModel
        resultRouteView.viewModel?.checkFirstItinerarie()
        
        configView(with: .populated)
    }
    
    func configMap(with viewModel: MainMapViewModel?) {
        guard let mapViewModel = viewModel else { return }
        
        mapView.viewModel = mapViewModel
        mapViewModel.showRoute()
    }
    
    func configTableView() {
        guard let resultListModel = viewModel.resultListViewModel else { return }
        dataSource = ResultListViewDataSource(viewModel: resultListModel)
        
        resultListView.tableView.dataSource = dataSource
        resultListView.tableView.delegate = self
        resultListView.tableView.reloadData()
        //resultListView.tableView.flashScrollIndicators()
        resultListView.isHidden = false
    }
    
    func configView(with state: MainViewModel.ViewState) {
        searchView.isHidden = true
        closeView.isHidden = true
        resultListView.isHidden = true
        resultRouteView.isHidden = true
        //Add More defautl Views
        
        switch state {
        case .initial:
            searchView.isHidden = false
        case .loading:
            print("Show Loading View")
        case .populated:
            closeView.isHidden = false
            resultRouteView.isHidden = false
        case .empty:
            print("Show Empty View")
        case .error:
            print("Show error View")
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
        viewModel.selectedResultListPlace(at: indexPath)
        resultListView.isHidden = true
    }
}

//MARK: - SearchViewDelegate

extension MainViewController: SearchViewDelegate {
    
    func searchViewDelegate(_ searchView: SearchView, didChangeSource source: ResultListViewModel) {
        viewModel.configResultListModel(with: source)
    }
    
    func searchViewDelegate(_ searchView: SearchView, planningTrip searchModel: SearchViewModel?) {
        guard let searchModel = searchModel else { return }
        viewModel.planningTrip(with: searchModel)
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
        configView(with: .initial)
    }
}
