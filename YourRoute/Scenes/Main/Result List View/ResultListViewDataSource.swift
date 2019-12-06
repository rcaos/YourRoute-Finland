//
//  ResultListViewDataSource.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class ResultListViewDataSource:NSObject,  UITableViewDataSource {

    private let viewModel: ResultListViewModel
    
    init(viewModel: ResultListViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check first for State
        return viewModel.placesCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //check first for State
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        //Inyect Model... viewModel.placeCells[indexPath.row]
        
        cell.textLabel?.text = viewModel.placesCells[indexPath.row].name
        return cell
    }

}
