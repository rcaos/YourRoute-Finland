//
//  CustomPolyLine.swift
//  YourRoute
//
//  Created by Jeans on 12/6/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import MapKit

class CustomMKPolyline: MKPolyline {
  
    var type: LegMode?
    
    var color: UIColor? {
        guard let type = type else { return nil }
        
        switch type {
        case .WALK:
            return .green
        case .BUS:
            return UIColor(red: 4/255, green: 166/255, blue: 255/255, alpha: 1.0)
        }
    }
    
    var width: CGFloat {
        guard let type = type else { return 1.0 }
        
        switch type {
        case .WALK:
            return 5.0
        case .BUS:
            return 3.0
        }
    }
    
    var dashPatter: [NSNumber] {
        guard let type = type else { return [] }
        
        switch type {
        case .WALK:
            return [0,8]
        case .BUS:
            return []
        }
    }
}
