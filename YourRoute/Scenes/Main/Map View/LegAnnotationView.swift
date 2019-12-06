//
//  LegView.swift
//  YourRoute
//
//  Created by Jeans on 12/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import MapKit

class LegAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if let place = newValue as? LegPlaceView {
                
                if let type = place.typePlace {
                    switch type {
                    case .origin:
                        markerTintColor = UIColor(red: 25/255, green: 175/255, blue: 51/255, alpha: 1.0)
                    default:
                        break
                    }
                }
            }
        }
    }
}
