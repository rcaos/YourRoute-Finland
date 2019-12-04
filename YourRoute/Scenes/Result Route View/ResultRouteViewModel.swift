//
//  ResultRouteViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultRouteViewModel {
    
    private var selectedRoute: Itinerarie?
    
    var optimeRoute: String?
    
    var otherRoutes: String?
    
    var infoAboutRoute: String?
    
    //MARK: - Life Cycle
    
    init(itineraries: [Itinerarie], selectedRoute: Itinerarie? = nil) {
        if let selected = selectedRoute {
            self.selectedRoute = selected
        } else {
            calculateOptimalRoute(for: itineraries)
        }
    }
    
    
    private func calculateOptimalRoute(for itineraries: [Itinerarie]) {
        
        print("Se recibieron \(itineraries.count) itinerarios")
        
        //For now temporarily
        if itineraries.count > 0 {
            selectedRoute = itineraries[0]
            setupView(for: selectedRoute)
        }
        
        if itineraries.count > 1 {
            otherRoutes = "Check other Routes (\(itineraries.count - 1))"
        } else {
            //disable "Check Other Routes"
        }
        
    }
    
    private func setupView(for itinerarie: Itinerarie?) {
        guard let itinerarie = itinerarie else { return }
        
        optimeRoute = "Fastest Route: \( Int(itinerarie.duration / 60)) mins"
        
        let numberOfBuses = itinerarie.legs.filter({ $0.mode == "BUS" }).count
        
        if  numberOfBuses > 1 {
            infoAboutRoute = "The route has \(numberOfBuses) buses"
        }
    }
    
    //MARK: - Build Models
    
    func buildDetailRouteViewModel() -> DetailRouteViewModel? {
        guard let itinerarie = selectedRoute else { return nil }
        
        return DetailRouteViewModel(itinerarie: itinerarie)
    }
}
