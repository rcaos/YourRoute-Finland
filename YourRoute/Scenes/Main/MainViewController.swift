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
    @IBOutlet weak var resultListView: ResultListView!
    @IBOutlet weak var resultRouteView: ResultRouteView!
    
    private var dataSource: ResultListViewDataSource!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
        setupModels()
        setupTableView()
        setupBindables()
        
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
        
        searchView.isHidden = true
        resultRouteView.isHidden = false
        resultRouteView.viewModel = ResultRouteViewModel(itineraries: itineraries)
    }
    //END:  Only for Tests
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        searchView.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0.58, alpha: 0)
        
        resultListView.isHidden = true
        resultRouteView.isHidden = true
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)) )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func hideKeyboard(_ sender: AnyObject?) {
        self.view.endEditing(true)
    }
    
    func setupModels() {
        searchView.delegate = self
        searchView.viewModel = viewModel.searchViewModel
        
        resultRouteView.delegate = self
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
        
        viewModel.showResultRoute = { [weak self] resultRouteViewModel, mapViewModel in
            guard let strongSelf = self else { return }
            strongSelf.resultRouteView.viewModel = resultRouteViewModel
            
            if let mapViewModel = mapViewModel {
                strongSelf.mapView.viewModel = mapViewModel
                mapViewModel.showRoute()
            }
            
            strongSelf.searchView.isHidden = true
            strongSelf.resultRouteView.isHidden = false
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailRouteSegue" {
            //if let destination = segue.destination as? DetailRouteViewController {
            if let navigation = segue.destination as? UINavigationController,
                let destination  = navigation.topViewController as? DetailRouteViewController {
                destination.viewModel = sender as? DetailRouteViewModel
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Select Cell at index: \(indexPath.row)")
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
}

//MARK: - ResultRouteViewDelegate

extension MainViewController: ResultRouteViewDelegate {
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didSelectRouteDetail detail: DetailRouteViewModel) {
        performSegue(withIdentifier: "DetailRouteSegue", sender: detail)
    }
    
}

