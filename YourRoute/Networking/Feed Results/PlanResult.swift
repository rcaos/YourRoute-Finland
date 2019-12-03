//
//  PlanResult.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct PlanResult: Decodable {
    
    var data: DataResult
}

struct DataResult: Decodable {
    
    var plan: ItinirarieResult
}

struct ItinirarieResult: Decodable {
    
    var itineraries: [Itinerarie]
}


