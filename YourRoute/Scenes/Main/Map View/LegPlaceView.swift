//
//  LegPlaceView.swift
//  YourRoute
//
//  Created by Jeans on 12/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import MapKit

class LegPlaceView: NSObject {
    
    var name: String?
    
    var latitude: Double
    
    var longitude: Double
    
    //var route: [CLLocationCoordinate2D]?
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

//MARK: - MKAnnotation Only for MapKit

extension LegPlaceView: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocation(latitude: latitude, longitude: longitude).coordinate
        }
    }
    
    var title: String? {
        get {
            return name
        }
    }
}
