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
    
    //MARK: - Life Cycle
    
    init(itineraries: [Itinerarie]) {
        print("Se recibieron \(itineraries.count) itinerarios para mostrar")
        self.itineraries = itineraries
        
        calculateOptimalRoute(for: itineraries)
    }
    
    private func calculateOptimalRoute(for itineraries: [Itinerarie]) {
        //MARK: - TODO
        //Order Itineraries by some kind of attribute
        //For now temporarily
    }
}
