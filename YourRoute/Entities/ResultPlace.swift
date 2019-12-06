//
//  ResultPlace.swift
//  YourRoute
//
//  Created by Jeans on 12/6/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct ResultPlace: Decodable {
    
    var name: String
    
    var coordinate: Coordinate
    
    var address: String?
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }
}

struct Coordinate: Decodable {
    
    var latitude: Double
    
    var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
