//
//  DetailRouteBusTableViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteBusTableViewModel {
    
    var startTime: String?
    
    var startPlace: String?
    
    var platForm: String?
    
    var busDescription: String?
    
    var stopsCount: String?
    
    var durationTrip: String?
    
    private var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    private var distanceFormatter: MeasurementFormatter {
        let distanceFormatter = MeasurementFormatter()
        distanceFormatter.unitStyle = .medium
        distanceFormatter.unitOptions = .naturalScale
        distanceFormatter.locale = Locale(identifier: "es_PE")
        return distanceFormatter
    }
    
    //MARK: - Life Cycle
    
    init(leg: Leg) {
        setupView(for: leg)
    }
    
    //MARK: - Private
    
    private func setupView(for leg: Leg) {
        let startDate = Date(timeIntervalSince1970: leg.startTime / 1000)
        startTime = timeFormatter.string(from: startDate)
        
        startPlace = leg.from?.name
        
        if let platformCode = leg.from?.stop?.platformCode {
            platForm = "Platform: \(platformCode)"
        } else {
            platForm = ""
        }
        
        if let busName = leg.route?.shortName {
            busDescription = "Bus \(busName)"
        } else {
            busDescription = ""
        }
        
        if leg.intermediateStops.count == 0 {
            stopsCount = "No stops"
        } else {
            stopsCount = "\(leg.intermediateStops.count) stops"
        }
        
        durationTrip = formatDuration(seconds: leg.duration)
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
        
        return "(\(result))"
    }
    
    
}
