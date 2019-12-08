//
//  MainMapViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

//Hacer el Modelo generico???
import CoreLocation

final class MainMapViewModel {
    
    //Su función es mostrar un Itinerarie
    private let itinerarie: Itinerarie
    
    var places: [LegPlaceView] = []
    
    var routes: [(type: LegMode, coordinates: [CLLocationCoordinate2D])] = []
    
    //Reactive
    var updateAnnotations: (()->Void)?
    
    init(itinerarie: Itinerarie) {
        self.itinerarie = itinerarie
    }
    
    func showRoute() {
        addMarkPlaces()
        decodedRoutes()
        updateAnnotations?()
    }
    
    //MARK: - for now only origin and destination
    
    private func addMarkPlaces() {
        
        if let place = itinerarie.originPlace {
            let origin = LegPlaceView(place: place, type: .origin)
            places.append(origin)
        }
        
        if let place = itinerarie.destinationPlace {
            let destination = LegPlaceView(place: place, type: .destination)
            places.append(destination)
        }
        
        //Missing the intermediate places
        //TODO
        for leg in itinerarie.legs {
            guard let mode = leg.legMode, case .BUS = mode else { continue }
            
            if let fromPlace = leg.from {
                let placeView = LegPlaceView(name: fromPlace.name ?? "",
                                         latitude: fromPlace.lat, longitude: fromPlace.lon,
                                        type: .busStation)
                places.append(placeView)
            }
            
            if let toPlace = leg.to {
                let placeView = LegPlaceView(name: toPlace.name ?? "",
                                             latitude: toPlace.lat, longitude: toPlace.lon,
                    type: .busStation)
                places.append(placeView)
            }
            
            
        }
    }
    
    //MARK: - Decoded Routes
    
    private func decodedRoutes() {
        for leg in itinerarie.legs {
            
            guard let mode = leg.legMode else { continue }
            
            if let coordinates = decodedSingleRoute(encoded: leg.legGeometry?.points) {
                routes.append( (type: mode , coordinates: coordinates) )
            }
        }
    }
    
    private func decodedSingleRoute(encoded: String?) -> [CLLocationCoordinate2D]? {
        guard let encodedString = encoded else { return nil }
        
        let decoded = Polyline(encodedPolyline: encodedString)
        guard let coordinates = decoded.coordinates else { return nil }
        
        return coordinates
    }
    
    func showRouteForTest() {
        //Mock data
        
        let from = LegPlaceView(name: "Kampii", latitude: 60.184229958105, longitude: 24.949350357055664)
        let to = LegPlaceView(name: "Bus Stop", latitude: 60.18433, longitude: 24.92357)
        places.append(from)
        places.append(to)
        
        let encodedPoints = "kvinJuzgwCB??b@@fACHTb@GTGR{B|HGRGRBDBDPZh@dAHLHN`AfBHLCFER_@tAk@nBCFM`@[hAGREPENsApEAFM`@GVSr@Sr@_@tAOd@@R@LBNPxBVxCH`AVbDPdB\\vEJVBLBRb@zEHrAp@xIDTDLJDA`@ANAPAD?HALATARf@NP|@C|@EpAOv@Mh@G`@C^?TNdE@TDv@P~EBTD|@@R@\\?b@AZCRENEHEFGHMRABMTMPCDEFFVBJBFDTFTJZb@rAFVPl@DJi@~@"
        let decoded = Polyline(encodedPolyline: encodedPoints)
        if let coordinates = decoded.coordinates  {
            routes.append( (type: .WALK, coordinates: coordinates) )
        }
        
        updateAnnotations?()
    }
}
