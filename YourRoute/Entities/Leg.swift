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
    
    var legGeometry: Geometry?
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
    
    var legMode: LegMode? {
        
        if let legMode = LegMode(rawValue: mode) {
            return legMode
        } else {
            return nil
        }
    }
    
}

//MARK: - LegType

enum LegType:String , Decodable {
    
    case origin
    
    case destination
    
}

//MARK: - LegMode

enum LegMode: String, Decodable {
    
    case WALK
    
    case BUS
}


//MARK: - Place

struct Place: Decodable {
    
    var name: String?
    
    var lat: Double
    
    var lon: Double
    
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

//MARK: - Geometry

struct Geometry: Decodable {
    
    var length: Int?
    
    var points: String?
}
