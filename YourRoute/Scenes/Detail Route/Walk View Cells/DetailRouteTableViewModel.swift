//
//  DetailRouteTableViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteTableViewModel {
    
    var startTime: String?
    
    var startPlace: String?
    
    var instructions: String?
    
    //MARK: - Life Cycle
    
    init(leg: Leg) {
        setupView(for: leg)
    }
    
    //MARK: - Private
    
    private func setupView(for leg: Leg) {
        //startTime = String( leg.startTime )
        startTime = "22:15"
        startPlace = "Kamppi, Helsinki"
        instructions = "Walk 300 m (\(leg.duration) min)"
    }
}
