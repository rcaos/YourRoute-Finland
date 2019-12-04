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
        
        planClient.getPlan(origin: originCoordinate, destination: destinationCoordinate, completion: { result in
            
            switch( result ) {
            case .success(let response):
                guard let itineraries = response?.data.plan.itineraries else { return }
                self.handleResponse(with: itineraries)
                
            case .failure(let error):
                print("error to Planning Trip: \(error.localizedDescription)")
                //set State == error
            }
            
        })
    }
    
    func handleResponse(with itineraries: [Itinerarie]) {
        //set State == Populated
        print("Main VM: Se recibieron \(itineraries.count) itinerarios")
        let resultRouteViewModel = ResultRouteViewModel(itineraries: itineraries)
        showResultRoute?(resultRouteViewModel)
        
        //set State == Empty
    }
    
    //MARK: - Build ViewModels
    
}