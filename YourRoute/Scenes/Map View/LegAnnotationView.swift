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
            if let legAnnotation = newValue as? LegPlaceView {
                glyphText = "🚕"
            }
        }
    }
}
