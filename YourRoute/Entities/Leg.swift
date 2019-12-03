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
}
