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
        resultRouteView.isHidden = false
        let testlegs = [
            Leg(startTime: 1575472391000.0, endTime: 1575472980000.0, mode: "WALK", duration: 589) ,
            Leg(startTime: 1575472980000.0, endTime: 1575474120000.0, mode: "RAIL", duration: 1140) ,
            Leg(startTime: 1575474120000.0, endTime: 1575474375000.0, mode: "WALK", duration: 255) ,
        ]
        let testItinerarie = Itinerarie(walkDistance: 300, duration: 120, legs: testlegs)
        resultRouteView.viewModel = ResultRouteViewModel(itineraries: [], selectedRoute: testItinerarie)
        //End Only for Test
    }
    
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
        print("tap here")
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
        
        viewModel.showResultRoute = { [weak self] resultRouteViewModel in
            guard let strongSelf = self else { return }
            strongSelf.resultRouteView.viewModel = resultRouteViewModel
            
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

