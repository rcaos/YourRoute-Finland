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
    
    var dataSource: SearchPlacesDataSource
    //private var dataSource: SearchPlacesAppleDataSource
    //var dataSource: SearchPlacesGoogleDataSource
    
    //En el Model tengo que tener un objeto encapsulado con las Coordenates
    
    var originPlace: ResultPlace? {
        didSet {
            if let place = originPlace {
                selectPlace?( place.name, .origin)
            }
        }
    }
    
    var destinationPlace: ResultPlace? {
        didSet {
            if let place = destinationPlace {
                selectPlace?( place.name, .destination)
            }
        }
    }
    
    //Reactive
    
    var selectPlace: ((String?, SearchBarType) -> Void)?
    
    var changeAppearance: ((SearchView.SearchBarState, SearchBarType) -> Void)?
    
    var changeDataSource: Bindable<(ResultListViewModel?)> = Bindable(nil)
    
    var planningTrip: (() -> Void)?
    
    //MARK: - Life Cycle
    
    init(dataSource: SearchPlacesDataSource) {
    //init(dataSource: SearchPlacesAppleDataSource) {
    //init(dataSource: SearchPlacesGoogleDataSource) {
        self.dataSource = dataSource
    }
    
    func textDidChange(with text: String, in bar: SearchBarType) {
        switch bar {
        case .origin:
            if checkName(with: text, for: originPlace) == false {
                changeAppearance?(.normal, bar)
                originPlace = nil
            }
        case .destination:
            if checkName(with: text, for: destinationPlace) == false {
                changeAppearance?(.normal, bar)
                destinationPlace = nil
            }
        }
    }
    
    private func checkName(with text: String, for place: ResultPlace?) -> Bool {
        guard let name = place?.name else { return false }
        return (name == text) ? true :  false
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
    
    private func processFetched(with response: [ResultPlace]) {
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
        
        planning()
    }
    
    //MARK: - Toogle Places
    
    func togglePlaces() {
        tooglePlaceBar()
        planning()
    }
    
    private func tooglePlaceBar() {
        selectPlace?("", .origin)
        selectPlace?("", .destination)
        
        let oldOrigin = originPlace
        let oldDestination = destinationPlace
        
        originPlace = oldDestination
        destinationPlace = oldOrigin
    }
    
    private func planning() {
        if let _ = originPlace, let _ = destinationPlace {
            planningTrip?()
        }
    }
}

extension SearchViewModel {
    
    enum SearchBarType {
        case origin
        
        case destination
    }
}

extension SearchViewModel {
    
    enum ViewState {
        case initial
        
        case loading
        
        case populated
        
        case empty
        
        case error
    }
}
