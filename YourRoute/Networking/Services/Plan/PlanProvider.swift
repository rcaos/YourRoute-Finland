//
//  PlanProvider.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum PlanProvider {
    
    case getPlan(Double, Double, Double, Double)
    
}

//MARK: - EndPoint

extension PlanProvider: EndPoint {
    
    var baseURL: String {
        return "https://api.digitransit.fi"
    }
    
    var path: String {
        return "/routing/v1/routers/finland/index/graphql"
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/graphql"]
    }
    
    var parameters: [String : Any]? {
        
        let originCoordinate:(latitude: Double, longitude: Double)
        let destinationCoordinate:(latitude: Double, longitude: Double)
        let numberOfItineraries = 5
        
        switch self {
        case .getPlan(let originLatitude, let originLongitude, let destinationLatitude, let destinationLongitude):
            originCoordinate.latitude = originLatitude
            originCoordinate.longitude = originLongitude
            
            destinationCoordinate.latitude = destinationLatitude
            destinationCoordinate.longitude = destinationLongitude
        }
        
        let bodyParams = """
        {
            plan(
                from: {lat: \(originCoordinate.latitude), lon: \(originCoordinate.longitude)}
                to: {lat: \(destinationCoordinate.latitude), lon: \(destinationCoordinate.longitude)}
                numItineraries: \(numberOfItineraries)
                transportModes: [ { mode: WALK}, { mode: BUS } ]
            ) {
                itineraries {
                    walkDistance,
                    duration,
                    legs {
                        mode
                        startTime
                        endTime
                        duration
                        distance
                        from {
                            name
                            stop {
                                code
                                desc
                                platformCode
                            }
                            lat
                            lon
                        }
                        to {
                            name
                            lat
                            lon
                        }
                        legGeometry {
                            length
                            points
                        }
                        route {
                            shortName
                        }
                        intermediateStops {
                            code
                        }
                    }
                }
            }
        }
        """
        return ["body": bodyParams]
    }
    
    var parameterEncoding: ParameterEncoding {
        return .bodyDefaultEncoding
    }
    
    var method: HTTPMethod {
        return .post
    }
}
