//
//  DetailRouteViewController.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

class DetailRouteViewController: UIViewController {
    
    var viewModel: DetailRouteViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        setupTable()
        setupButtons()
    }
    
    func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        let nibDefault = UINib(nibName: "DetailRouteTableViewCell", bundle: nil)
        tableView.register(nibDefault, forCellReuseIdentifier: "DetailRouteTableViewCell")
        
        let nibBus = UINib(nibName: "DetailRouteBusTableViewCell", bundle: nil)
        tableView.register(nibBus, forCellReuseIdentifier: "DetailRouteBusTableViewCell")
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func setupButtons() {
        //closeButton.addTarget(self, action: #selector(self.closeView(sender:)), for: .touchUpInside)
        closeButton.target = self
        closeButton.action = #selector(self.closeView(sender:))
    }
    
    func setupViewModel() {
        
    }
    
    @objc func closeView(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension DetailRouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.legs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        let mode = viewModel.getMode(at: indexPath)
        switch mode {
        case .walk:
            return walkModeDataSource(tableView, indexPath: indexPath)
        case .bus:
            return busModeDataSource(tableView, indexPath: indexPath)
        default:
            return defaultModeDataSource(tableView, indexPath: indexPath)
        }
    }
    
    fileprivate func walkModeDataSource(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailRouteTableViewCell", for: indexPath) as? DetailRouteTableViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel?.getWalkModel(for: indexPath)
        return cell
    }
    
    fileprivate func busModeDataSource(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailRouteBusTableViewCell", for: indexPath) as? DetailRouteBusTableViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel?.getBusModel(for: indexPath)
        return cell
    }
    
    fileprivate func defaultModeDataSource(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        //let text = "\(leg.mode) for: \(leg.duration / 60) mins"
        let leg = viewModel?.legs[indexPath.row]
        //cell.textLabel?.text = "defaultCell no Implementation"
        cell.textLabel?.text = "\(leg?.mode) - \(leg?.duration) min"

        return cell
    }
    
}
