//
//  DetailRouteViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteViewModel {
    
//    var legCells: [DetailRouteTableViewModel] {
//        return legs.map({ return DetailRouteTableViewModel(leg: $0)  })
//    }
//    
    var legs: [Leg]
    
    private var itinerarie: Itinerarie
    
    init(itinerarie : Itinerarie) {
        self.itinerarie = itinerarie
        self.legs = itinerarie.legs
        
//        for leg in legs {
//            print(leg)
//        }
        formatOriginPoint()
        addDestinationPoint()
    }
    
    private func formatOriginPoint() {
        guard var leg = legs.first ,
            let fromPlace = leg.from,
            let namePlace = fromPlace.name,
            namePlace == "Origin" else { return }
        
        leg.from?.name = itinerarie.originPlace
        leg.type = "origin"
        legs[legs.startIndex] = leg
    }
    
    private func addDestinationPoint() {
        let startTime = getTimeDestination()
        let endLeg = Leg(startTime: startTime, endTime: 0, mode: "WALK", duration: 0, distance: 0,
                         from: Place(name: itinerarie.destinationPlace, lat: 0, lon: 0,stop: nil),
                      to: nil,
                      route: nil, intermediateStops: [],
                      type: "destination",
                      legGeometry: nil)
        self.legs.append( endLeg )
    }
    
    private func getTimeDestination() -> Double {
        guard let lastLeg = legs.last,
            let toPlace = lastLeg.to,
            let namePlace = toPlace.name,
            namePlace == "Destination" else { return 0 }
        
        return lastLeg.endTime
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
    
    func getWalkModel(for index: IndexPath) -> DetailRouteTableViewModel {
        return DetailRouteTableViewModel(leg: legs[index.row])
    }
    
    func getBusModel(for index: IndexPath) -> DetailRouteBusTableViewModel {
        return DetailRouteBusTableViewModel(leg: legs[index.row])
    }
}

enum ItinerarieModeCell {
    case walk
    
    case bus
    
    case noImplementation
}
