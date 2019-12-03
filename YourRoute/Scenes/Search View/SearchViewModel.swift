//
//  SearchViewModel.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

final class SearchViewModel {
    
    private var barSelected: SearchBarType?
    
    private var dataSource: SearchPlacesDataSource
    
    //En el Model tengo que tener un objeto encapsulado con las Coordenates
    
    private var originPlace: ResultPlace?
    
    private var destinationPlace: ResultPlace?
    
    //Reactive
    
    var changeDataSource: Bindable<(ResultListViewModel?)> = Bindable(nil)
    
    var selectPlace: ((String, SearchBarType ) -> Void)?
    
    //MARK: - Life Cycle
    
    init(dataSource: SearchPlacesDataSource) {
        self.dataSource = dataSource
    }
    
    func searchPlace(with text: String, in bar: SearchBarType) {
        //State Loading...
        //print("state in Search Loading...")
        barSelected = bar
        
        dataSource.search(with: text, completion: { result in
            switch result {
            case .success(let response):
                self.processFetched(with: response)
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
    }
    
    func processFetched(with response: [ResultPlace]) {
        print("fetched: [\(response.count)]")
        changeDataSource.value = buildDataSource(with: response)
    }
    
    func buildDataSource(with places: [ResultPlace]) -> ResultListViewModel {
        let viewModel = ResultListViewModel(places: places)
        return viewModel
    }
    
    //MARK: - Selected Place
    
    func selectPlace(at indexPath: IndexPath) {
        guard let selectedBar = barSelected ,
        let model = changeDataSource.value else { return }
        
        let placeSelected = model.placesCells[indexPath.row]
        
        switch selectedBar {
        case .origin:
            originPlace = placeSelected
        case .destination:
            destinationPlace = placeSelected
        }
        
        //MARK: - TODO mostrar formatted name Place
        let placeDescription = placeSelected.name
        selectPlace?(placeDescription, selectedBar)
        
        //MARK: -
        if let origin = originPlace, let destination = destinationPlace {
            print("recien conectar a servidor Graph con: Origin: [\(origin.coordinate)], Destination: [\(destination.coordinate)]")
        }
    }
}

extension SearchViewModel {
    
    enum SearchBarType {
        case origin
        
        case destination
    }
}
