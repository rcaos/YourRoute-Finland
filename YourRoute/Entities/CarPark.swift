//
//  CarPark.swift
//  YourRoute
//
//  Created by Jeans on 11/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct CarPark {
    
    var name: String
    var maxCapacity: Int
    var spacesAvailable: Int
    var latitude: Double
    var longitude: Double
}

extension CarPark: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case maxCapacity
        case spacesAvailable
        case latitude = "lat"
        case longitude = "lon"
    }
}
