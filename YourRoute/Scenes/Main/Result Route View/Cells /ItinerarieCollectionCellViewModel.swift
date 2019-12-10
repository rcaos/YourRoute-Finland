//
//  ItinerarieCollectionCellViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/10/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ItinerarieCollectionCellViewModel {
    
    var itinerarieDuration: String?
    
    var walkDuration: String?
    
    var walkDistance: String?
    
    var busDuration: String?
    
    var busCount: String?
    
    private var distanceFormatter: MeasurementFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        
        let distanceFormatter = MeasurementFormatter()
        distanceFormatter.unitStyle = .medium
        distanceFormatter.unitOptions = .naturalScale
        distanceFormatter.locale = Locale(identifier: "es_PE")
        distanceFormatter.numberFormatter = numberFormatter

        return distanceFormatter
    }
    
    private var itinerarie: Itinerarie
    
    //MARK: - Life Cycle
    
    init(itinerarie: Itinerarie) {
        self.itinerarie = itinerarie
        
        setupView(for: itinerarie)
    }
    
    private func setupView(for itinerarie: Itinerarie) {
        
        itinerarieDuration = formatDuration(seconds: itinerarie.duration)
        walkDuration = formatDuration(seconds: itinerarie.walkDuration)
        
        let distanceInMeters = Measurement(value: itinerarie.walkDistance, unit: UnitLength.meters)
        let distanceFormat = distanceFormatter.string(from: distanceInMeters)
        walkDistance = "Total Walk: \(distanceFormat)"
        
        let onlyBuses = itinerarie.legs.filter({ $0.mode == "BUS" })
        
        let busesDuration = onlyBuses.reduce(0) { $0 + $1.duration }
        busDuration = formatDuration(seconds: busesDuration)
        
        let numberOfBuses = onlyBuses.count
        if  numberOfBuses > 1 {
            busCount = "\(numberOfBuses) buses to take"
        }
    }
    
    private func formatDuration(seconds: Double) -> String {
        
        let duration: TimeInterval = seconds
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.startOfDay(for: date)
        let newDate = start.addingTimeInterval(duration)
        
        let formatter = DateFormatter()
        
        var result = ""
        
        if duration < 60 {
            formatter.dateFormat = "ss"
            result = "\(formatter.string(from: newDate)) s"
        } else if duration >= 60 && duration < 3600 {
            formatter.dateFormat = "mm"
            result = "\(formatter.string(from: newDate)) min"
        } else {
            formatter.dateFormat = "HH"
            let hour = formatter.string(from: newDate)
            
            formatter.dateFormat = "mm"
            let min = formatter.string(from: newDate)
            result = "\(hour) h \(min) min"
        }
        
        return result
    }
    
    //MARK: - Build View Models
    
    func buildDetailRouteViewModel() -> DetailRouteViewModel {
        return DetailRouteViewModel(itinerarie: itinerarie)
    }
}
