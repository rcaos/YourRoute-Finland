//
//  DetailRouteViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteViewModel {
    
    var legCells: [DetailRouteTableViewModel] {
        return legs.map({ return DetailRouteTableViewModel(leg: $0)  })
    }
    
    var legs: [Leg]
    
    init(itinerarie : Itinerarie) {
        self.legs = itinerarie.legs
    }
    
    func getMode(at indexPath: IndexPath) -> ItinerarieModeCell {
        let leg = legs[indexPath.row]
        if leg.mode == "WALK" {
            return .walk
            
        } else if leg.mode == "BUS" {
            return .bus
            
        } else {
            return .noImplementation
        }
        
    }
}

enum ItinerarieModeCell {
    case walk
    
    case bus
    
    case noImplementation
}
