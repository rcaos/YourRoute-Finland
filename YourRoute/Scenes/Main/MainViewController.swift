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
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Select Cell at index: \(indexPath.row)")
        viewModel.selectedResultListPlace(at: indexPath)
        resultListView.isHidden = true
    }
}

extension MainViewController: SearchViewDelegate {
    
    func searchViewDelegate(_ searchMoviesResultController: SearchView, didChangeSource source: ResultListViewModel) {
        //print("print SearchViewDelegate")
        //configTableView(with: source)
        viewModel.configResultListModel(with: source)
    }
}


