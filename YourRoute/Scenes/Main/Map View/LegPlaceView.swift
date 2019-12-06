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
    
    var place: ResultPlace
    
    var typePlace: LegType?
    
    init(name: String, latitude: Double, longitude: Double, type: LegType? = nil) {
        self.place = ResultPlace(name: name, latitude: latitude, longitude: longitude)
        self.typePlace = type
    }
    
    init(place: ResultPlace, type: LegType? = nil) {
        self.place = place
        self.typePlace = type
    }
}

//MARK: - MKAnnotation Only for MapKit

extension LegPlaceView: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocation(latitude: place.coordinate.latitude,
                              longitude: place.coordinate.longitude).coordinate
        }
    }
    
    var title: String? {
        get {
            return place.name
        }
    }
}
