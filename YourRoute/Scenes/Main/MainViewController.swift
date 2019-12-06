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
        //setupTest()
        setupTestShowRoute()
    }
    
    //MARK: - only for Test
    
    func setupTestShowRoute() {
        let mapViewModel = MainMapViewModel()
        mapView.viewModel = mapViewModel
        mapViewModel.showRoute()
    }
    
    func setupTestDetailItinerarie() {
        resultRouteView.isHidden = false
        
        var testLegs = [Leg]()
        testLegs.append(
        Leg(startTime: 1575495226000.0, endTime: 1575495748000.0,
                      mode: "WALK", duration: 40, distance: 428,
                      from: Place(name: "Origin", lat: 0, lon: 0, stop: nil),
                      to: nil,
                    route: nil, intermediateStops: [],
                    type: nil,
                    legGeometry: nil) )
        
        testLegs.append(
        Leg(startTime: 1575495748000.0, endTime: 1575496034000.0,
            mode: "BUS", duration: 286, distance: 5430,
            from: Place(name: "Haapaniemi", lat: 0, lon: 0,
                        stop: Stop(code: "2406", desc: "Hämeentie 16", platformCode: nil)),
            to: nil,
        route: Route(shortName: "65"),
        intermediateStops: [],
        type: nil,
        legGeometry: nil) )
        
        testLegs.append(
        Leg(startTime: 1575496034000.0, endTime: 1575496640000.0,
            mode: "WALK", duration: 606, distance: 1230,
            from: Place(name: Optional("Rautatientori"), lat: 0, lon: 0,
                        stop: Stop(code: Optional("2139"), desc: Optional("Vilhonkatu"), platformCode: nil)),
            to: nil,
            route: nil, intermediateStops: [],
            type: nil,
            legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575498120000.0, endTime: 1575499800000.0,
                mode: "BUS", duration: 1680, distance: 12450,
                from: Place(name: Optional("Kamppi"), lat: 0, lon: 0,
                            stop: Stop(code: Optional("1249"), desc: Optional("Kamppi"), platformCode: "49")),
                to: nil,
        route: Route(shortName: "134N"),
                intermediateStops:
                [Optional(YourRoute.Stop(code: Optional("1234"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("1011"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2205"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2037"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2016"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2151"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2132"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3227"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3228"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3256"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3268"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3266"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3263"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3204"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3206"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3224"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3209"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4934"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4325"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4327"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4301"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6167"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6171"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6015"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6025"), desc: nil, platformCode: nil))],
                type: nil,
                legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575499800000.0, endTime: 1575500314000.0,
                mode: "WALK", duration: 3750, distance: 300,
                from: Place(name: "Espoon asema", lat: 0, lon: 0,
                            stop: Stop(code: "E6024", desc: Optional("Siltakatu"), platformCode: "22")),
                to: nil,
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: nil) )
        
        let testItinerarie = Itinerarie(walkDistance: 300, duration: 120, legs: testLegs,
                                        originPlace: "Kamppi, Helsinki - Start", destinationPlace: "Espoo, Espoo - End")
        resultRouteView.viewModel = ResultRouteViewModel(itineraries: [], selectedRoute: testItinerarie)
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

