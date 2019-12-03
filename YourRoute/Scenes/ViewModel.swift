//
//  ViewModel.swift
//  YourRoute
//
//  Created by Jeans on 11/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreLocation

final class ViewModel {
    
    let client = CarParksClient()
    
    var currentLocation: CLLocation?
    
    var parkings: [CarPark] = []
    
    var annotations: [CarParkAnnotation] {
        return parkings.map({ CarParkAnnotation(name: $0.name, latitude: $0.latitude, longitude: $0.longitude) })
    }
    
    //Reactive
    var reloadAnnotations: (()->Void)?
    
    //MARK: - Init
    
    init() {
        currentLocation = CLLocation(latitude: 60.1706, longitude: 24.9375)
    }
    
    func getParkings() {
        client.getAll(completion: { result in
            switch result {
            case .success(let response):
                if let parkins = response?.data.carParks {
                    print("total fetched: \(parkins.count)")
                    self.processResult(parkins: parkins)
                }
                
            case .failure(let error):
                print("error fetched \(error)")
            }
        })
    }
    
    private func processResult(parkins: [CarPark]) {
        
        let filtered = parkins.filter({
            let location = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            
            if let distance: Double = currentLocation?.distance(from: location) {
                if distance < 5000.00 {
                    return true
                }
            }
            return false
        })
        
        //MARK: - Only first 10 carParks
        if filtered.count > 10 {
            self.parkings = Array(filtered[0...9])
        } else {
            self.parkings = filtered
        }
        
        reloadAnnotations?()
    }
}
