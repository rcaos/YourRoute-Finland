//
//  MainViewModel.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MainViewModel {
    
    private var dataSource: SearchPlacesDataSource
    
    var searchViewModel: SearchViewModel
    
    var resultListViewModel: ResultListViewModel?
    
    //Reactive
    var reloadTable: (()->Void)?
    
    //MARK: - Life Cycle
    
    init() {
        dataSource = SearchPlacesDataSource()
        searchViewModel = SearchViewModel(dataSource: dataSource)
    }
    
    func configResultListModel(with model: ResultListViewModel) {
        resultListViewModel = model
        reloadTable?()
    }
    
    func selectedResultListPlace(at indexPath: IndexPath) {
        searchViewModel.selectPlace(at: indexPath)
    }
    
}
