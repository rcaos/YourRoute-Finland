//
//  Leg.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct Leg: Decodable {
    
    var startTime: Double
    
    var endTime: Double
    
    var mode: String
    
    var duration: Int
    
    var from: Place?
    
    var route: Route?
    
    var intermediateStops: [Stop?]
}

//MARK: - Place

struct Place: Decodable {
    
    var name: String?
    
    var stop: Stop?
}

//MARK: - Route

struct Route: Decodable {
    
    var shortName: String?
}

//MARK: - Stop

struct Stop: Decodable {
    
    var code: String?
    
    var desc: String?
    
    var platformCode: String?
}

