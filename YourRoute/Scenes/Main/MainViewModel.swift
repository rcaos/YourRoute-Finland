//
//  MainViewModel.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MainViewModel {
    
    private var planClient: PlanClient = PlanClient()
    
    private var dataSource: SearchPlacesDataSource
    
    var searchViewModel: SearchViewModel
    
    var mapViewModel: MainMapViewModel?
    
    var resultListViewModel: ResultListViewModel?
    
    //Reactive
    
    var reloadTable: (()->Void)?
    
    var showResultRoute: ((ResultRouteViewModel)->Void)?
    
    var viewState: Bindable<MainViewModel.ViewState> = Bindable(.initial)
    
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
    
    func planningTrip(with model: SearchViewModel) {
        guard let origin = model.originPlace, let destination = model.destinationPlace else { return }
        
        let originCoordinate = (latitude: origin.coordinate.latitude, longitude: origin.coordinate.longitude)
        let destinationCoordinate = (latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude)
        
        viewState.value = .loading
        
        planClient.getPlan(origin: originCoordinate, destination: destinationCoordinate, completion: { result in
            
            switch( result ) {
            case .success(let response):
                guard let itineraries = response?.data.plan.itineraries else { return }
                self.handleResponse(with: itineraries, originPlace: origin, destinationPlace: destination)
                
            case .failure(let error):
                print("error to Planning Trip: \(error.localizedDescription)")
                
                self.viewState.value = .error
            }
        })
    }
    
    private func handleResponse(with itineraries: [Itinerarie], originPlace: ResultPlace?, destinationPlace: ResultPlace?) {
        
        var newItineraries = itineraries
        
        //MARK: - TODO its really needed??
        for index in newItineraries.indices {
            newItineraries[index].originPlace = originPlace
            newItineraries[index].destinationPlace = destinationPlace
        }
        
        print("Fetched: \(newItineraries.count) itineraries")
        let resultRouteViewModel = ResultRouteViewModel(itineraries: newItineraries)
        
        if newItineraries.count > 0 {
            viewState.value = .populated
            showResultRoute?(resultRouteViewModel)
        } else {
            viewState.value = .error
        }
    }
    
    //MARK: - Build Models
    
    func getMapViewModel() -> MainMapViewModel {
        switch viewState.value {
        case .initial:
            return buildInitialItinerarie()
        case .loading:
            return buildEmptyItinerarie(with: searchViewModel)
        case .populated:
            guard let mapModel = mapViewModel else { return buildInitialItinerarie() }
            return mapModel
        case .error:
            return buildInitialItinerarie()
        }
    }
    
    private func buildEmptyItinerarie(with model: SearchViewModel) -> MainMapViewModel {
        guard let origin = model.originPlace, let destination = model.destinationPlace else {
            return buildInitialItinerarie() }
        
        let itinerarie = Itinerarie(walkDistance: 0, walkDuration: 0, duration: 0, legs: [],
                                    originPlace: origin,
                                    destinationPlace: destination)
        return MainMapViewModel(itinerarie: itinerarie)
    }
    
    private func buildInitialItinerarie() -> MainMapViewModel {
        let itinerarie = Itinerarie(walkDistance: 0, walkDuration: 0, duration: 0, legs: [], originPlace: nil, destinationPlace: nil)
        return MainMapViewModel(itinerarie: itinerarie)
    }
}

extension MainViewModel {
    
    enum ViewState {
        case initial
        
        case loading
        
        case populated
        
        case error
    }
}
