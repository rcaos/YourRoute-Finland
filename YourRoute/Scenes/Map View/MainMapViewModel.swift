//
//  MainMapViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

//Hacer el Modelo generico???
import CoreLocation

final class MainMapViewModel {
    
    var places: [LegPlaceView] = []
    
    var route: [CLLocationCoordinate2D] = []
    
    //Reactive
    var updateAnnotations: (()->Void)?
    
    init() {
        
    }
    
    func showRoute() {
        //Mock data
        
        //let from = LegPlaceView(name: "Kampii", latitude: 60.184229958105, longitude: 24.949350357055664)
        //let to = LegPlaceView(name: "Bus Stop", latitude: 60.18287, longitude: 24.94524)
        
        let from = LegPlaceView(name: "Kampii", latitude: 60.184229958105, longitude: 24.949350357055664)
        let to = LegPlaceView(name: "Bus Stop", latitude: 60.18433, longitude: 24.92357)
        places.append(from)
        places.append(to)
        
        let encodedPoints = "kvinJuzgwCB??b@@fACHTb@GTGR{B|HGRGRBDBDPZh@dAHLHN`AfBHLCFER_@tAk@nBCFM`@[hAGREPENsApEAFM`@GVSr@Sr@_@tAOd@@R@LBNPxBVxCH`AVbDPdB\\vEJVBLBRb@zEHrAp@xIDTDLJDA`@ANAPAD?HALATARf@NP|@C|@EpAOv@Mh@G`@C^?TNdE@TDv@P~EBTD|@@R@\\?b@AZCRENEHEFGHMRABMTMPCDEFFVBJBFDTFTJZb@rAFVPl@DJi@~@"
        let decoded = Polyline(encodedPolyline: encodedPoints)
        if let coordinates = decoded.coordinates  {
            route = coordinates
        }
        
        updateAnnotations?()
    }
}
