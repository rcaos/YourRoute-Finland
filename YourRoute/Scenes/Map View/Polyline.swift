//
//  Polyline.swift
//  YourRoute
//
//  Created by Jeans on 12/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreLocation

public struct Polyline {
    
    public let encodedPolyline: String
    
    public var coordinates: [CLLocationCoordinate2D]?
    
    public var locations: [CLLocation]? {
        return coordinates.map(toLocations)
    }
    
    public init(encodedPolyline: String, precision: Double = 1e5) {
        self.encodedPolyline = encodedPolyline
        coordinates = decodePolyline(encodedPolyline, precision: precision)
    }
    
    private func decodePolyline(_ encodedPolyline: String, precision: Double = 1e5) -> [CLLocationCoordinate2D]? {
        
        let data = encodedPolyline.data(using: String.Encoding.utf8)!
        
        let byteArray = (data as NSData).bytes.assumingMemoryBound(to: Int8.self)
        let length = Int(data.count)
        var position = Int(0)
        
        var decodedCoordinates = [CLLocationCoordinate2D]()
        
        var lat = 0.0
        var lon = 0.0
        
        while position < length {
            
            do {
                let resultingLat = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lat += resultingLat
                
                let resultingLon = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lon += resultingLon
            } catch {
                return nil
            }
            
            decodedCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        return decodedCoordinates
    }
    
    private func decodeSingleCoordinate(byteArray: UnsafePointer<Int8>, length: Int, position: inout Int, precision: Double = 1e5) throws -> Double {
        
        guard position < length else { throw PolylineError.singleCoordinateDecodingError }
        
        let bitMask = Int8(0x1F)
        
        var coordinate: Int32 = 0
        
        var currentChar: Int8
        var componentCounter: Int32 = 0
        var component: Int32 = 0
        
        repeat {
            currentChar = byteArray[position] - 63
            component = Int32(currentChar & bitMask)
            coordinate |= (component << (5*componentCounter))
            position += 1
            componentCounter += 1
        } while ((currentChar & 0x20) == 0x20) && (position < length) && (componentCounter < 6)
        
        if (componentCounter == 6) && ((currentChar & 0x20) == 0x20) {
            throw PolylineError.singleCoordinateDecodingError
        }
        
        if (coordinate & 0x01) == 0x01 {
            coordinate = ~(coordinate >> 1)
        } else {
            coordinate = coordinate >> 1
        }
        
        return Double(coordinate) / precision
    }
    
    private func toLocations(_ coordinates: [CLLocationCoordinate2D]) -> [CLLocation] {
        return coordinates.map { coordinate in
            CLLocation(latitude:coordinate.latitude, longitude:coordinate.longitude)
        }
    }
    
    enum PolylineError: Error {
        case singleCoordinateDecodingError
        case chunkExtractingError
    }
}
