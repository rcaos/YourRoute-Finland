//
//  CarParkAnnotation.swift
//  YourRoute
//
//  Created by Jeans on 11/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class CarParkAnnotation: NSObject {
    
    var name: String
    var location: CLLocation
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
}

//MARK: - MKAnnotation

extension CarParkAnnotation: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String? {
        return name
    }
}
