//
//  DetailRouteBusTableViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteBusTableViewModel {
    
    var startTime: String?
    
    var startPlace: String?
    
    var platForm: String?
    
    var busDescription: String?
    
    var stopsCount: String?
    
    var durationTrip: String?
    
    //MARK: - Life Cycle
    
    init(leg: Leg) {
        setupView(for: leg)
    }
    
    //MARK: - Private
    
    private func setupView(for leg: Leg) {
        //startTime = String( leg.startTime )
        startTime = "22:15"
        startPlace = "Kamppi"
        platForm = "Platform 41"
        
        busDescription = "Bus 345N"
        
        stopsCount = "32 stops"
        durationTrip = "(28 min)"
    }
    
    
}
