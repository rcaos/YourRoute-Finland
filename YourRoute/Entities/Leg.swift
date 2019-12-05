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
    
    var duration: Double
    
    var distance: Double
    
    var from: Place?
    
    var to: Place?
    
    var route: Route?
    
    var intermediateStops: [Stop?]
    
    var type: String?
}

//MARK: - Extension Leg

extension Leg {
    
    var legType: LegType? {
        if let stringType = type,
            let legType = LegType(rawValue: stringType) {
            return legType
        } else {
            return nil
        }
    }
    
}

//MARK: - LegType

enum LegType:String , Decodable{
    
    case origin
    
    case destination
    
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

