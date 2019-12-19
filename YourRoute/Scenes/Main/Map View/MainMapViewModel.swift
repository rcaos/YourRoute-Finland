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
    //Pero si está en estado Loading???
    //Solo mostrar Origin y End por ejemplo.
    private let itinerarie: Itinerarie
    
    var places: [LegPlaceView] = []
    
    var routes: [(type: LegMode, coordinates: [CLLocationCoordinate2D])] = []
    
    var routesGoogle: [(type: LegMode, encodedPath: String)] = []
    
    var viewState: Bindable<MainMapViewModel.ViewState> = Bindable(.initial)
    
    init(itinerarie: Itinerarie) {
        self.itinerarie = itinerarie
        showRoute()
    }
    
    func showRoute() {
        places = buildMarkPlaces()
        routes = buildRoutes()
        
        routesGoogle = buildRoutesGoogle()
        
        checkState()
    }
    
    private func checkState() {
        if itinerarie.originPlace == nil || itinerarie.destinationPlace == nil {
            viewState.value = .initial
            return
        }
        
        if itinerarie.legs.count == 0 {
            viewState.value = .empty
        } else {
            viewState.value = .populated
        }
    }
    
    //MARK: - for now only origin and destination
    
    private func buildMarkPlaces() -> [LegPlaceView] {
        
        var places: [LegPlaceView] = []
        
        if let place = itinerarie.originPlace {
            let origin = LegPlaceView(place: place, type: .origin)
            places.append(origin)
        }
        
        if let place = itinerarie.destinationPlace {
            let destination = LegPlaceView(place: place, type: .destination)
            places.append(destination)
        }
        
        //Missing the intermediate places
        //MARK: - TODO
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
        
        return places
    }
    
    //MARK: - Decoded Routes
    
    private func buildRoutes() -> [(LegMode,[CLLocationCoordinate2D])] {
        var routes: [(type: LegMode, coordinates: [CLLocationCoordinate2D])] = []
        
        for leg in itinerarie.legs {
            
            guard let mode = leg.legMode else { continue }
            
            if let coordinates = decodedSingleRoute(encoded: leg.legGeometry?.points) {
                routes.append( (type: mode , coordinates: coordinates) )
            }
        }
        return routes
    }
    
    private func decodedSingleRoute(encoded: String?) -> [CLLocationCoordinate2D]? {
        guard let encodedString = encoded else { return nil }
        
        let decoded = Polyline(encodedPolyline: encodedString)
        guard let coordinates = decoded.coordinates else { return nil }
        
        return coordinates
    }
    
    private func buildRoutesGoogle() -> [(type: LegMode, encodedPath: String)] {
        var routes: [(type: LegMode, encodedPath: String)] = []
        
        for leg in itinerarie.legs {
            guard let mode = leg.legMode,
                let encoded = leg.legGeometry?.points else { continue }
            routes.append( (type: mode , encodedPath: encoded) )
        }
        return routes
    }
    
}

extension MainMapViewModel {
    
    enum ViewState {
        case initial
        
        case empty
        
        case populated
    }
}
