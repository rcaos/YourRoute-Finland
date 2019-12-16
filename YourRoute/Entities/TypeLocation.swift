//
//  TypeLocation.swift
//  YourRoute
//
//  Created by Jeans on 12/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum TypeLocation {
    
    case userLocation(ResultPlace)
    
    case defaultLocation(ResultPlace)
    
    var radius: Double {
        switch self {
        case .userLocation(_):
            return 50.0
        case .defaultLocation(_):
            return 1000.0
        }
    }
}
