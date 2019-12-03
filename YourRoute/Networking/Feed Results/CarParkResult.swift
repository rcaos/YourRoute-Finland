//
//  CarParkResult.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct CarParkResult: Decodable {
    var data: CarParkResponse
}

struct CarParkResponse: Decodable {
    var carParks: [CarPark]
}
