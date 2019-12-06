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
    
    var duration: Int
    
    var legs: [Leg]
    
    var originPlace: ResultPlace?
    
    var destinationPlace: ResultPlace?
}


