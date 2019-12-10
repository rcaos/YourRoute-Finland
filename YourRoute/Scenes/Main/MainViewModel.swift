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
        
        //MARK: - TODO set State = Loading..
        
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
            viewState.value = .empty
        }
    }
}

extension MainViewModel {
    
    enum ViewState {
        case initial
        
        case loading
        
        case populated
        
        case empty
        
        case error
    }
}
