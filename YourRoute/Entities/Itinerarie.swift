//
//  Itinerarie.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct Itinerarie: Decodable {
    
    var walkDistance: Double
    
    var walkDuration: Double
    
    var duration: Double
    
    var legs: [Leg]
    
    var originPlace: ResultPlace?
    
    var destinationPlace: ResultPlace?
    
    //MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        
        case walkDistance
        case walkDuration = "walkTime"
        case duration
        case legs
        case originPlace
        case destinationPlace
        
    }
}


