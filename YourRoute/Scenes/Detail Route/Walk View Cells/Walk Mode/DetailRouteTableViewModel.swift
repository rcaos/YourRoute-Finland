//
//  DetailRouteTableViewModel.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class DetailRouteTableViewModel {
    
    var startTime: String?
    
    var startPlace: String?
    
    var instructions: String?
    
    var placeHolderImage: String?
    
    var isHiddenDots: Bool?
    
    private var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
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
    
    //MARK: - Life Cycle
    
    init(leg: Leg) {
        setupView(for: leg)
        setupImagePlaceHolder(for: leg)
    }
    
    //MARK: - Private
    
    private func setupView(for leg: Leg) {
        let startDate = Date(timeIntervalSince1970: leg.startTime / 1000)
        startTime = timeFormatter.string(from: startDate)
        
        startPlace = leg.from?.name
        
        if leg.distance > 0 {
            let distanceInMeters = Measurement(value: leg.distance, unit: UnitLength.meters)
            let distance = distanceFormatter.string(from: distanceInMeters)
            
            let duration = formatDuration(seconds: leg.duration)
            instructions = "Walk \(distance) (\(duration))"
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
    
    func setupImagePlaceHolder(for leg: Leg) {
        guard let type = leg.legType else { return }
        
        switch type {
        case .origin:
            placeHolderImage = "origin"
            isHiddenDots = false
        case .destination:
            placeHolderImage = "destination"
            isHiddenDots = true
        }
    }
}
