//
//  ResultRouteViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultRouteViewModel {
    
    private var itineraries: [Itinerarie] = []
    
    var itinerariesCells: [ItinerarieCollectionCellViewModel] {
        return itineraries.map{ ItinerarieCollectionCellViewModel(itinerarie: $0) }
    }
    
    var showRoute: ((Int) -> Void)?
    
    //MARK: - Life Cycle
    
    init(itineraries: [Itinerarie]) {
        self.itineraries = itineraries
        
        calculateOptimalRoute(for: itineraries)
    }
    
    private func calculateOptimalRoute(for itineraries: [Itinerarie]) {
        //MARK: - TODO
        //Order Itineraries by some kind of attribute,
        //Less walk?
        //For now temporarily
    }
    
    func checkFirstItinerarie() {
        if let _ = itineraries.first {
            showRoute?(0)
        }
    }
    
    //MARK: - Build Models
    
    func buildMapViewModel(for index: Int) -> MainMapViewModel {
        return MainMapViewModel(itinerarie: itineraries[index])
    }
}
