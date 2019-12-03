//
//  CarParkProvider.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum CarParkProvider {
    
    case getAllCarParks
    
}

//MARK: - EndPoint

extension CarParkProvider: EndPoint {
    
    var baseURL: String {
        return "https://api.digitransit.fi"
    }
    
    var path: String {
        return "/routing/v1/routers/hsl/index/graphql"
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/graphql"]
    }
    
    var parameters: [String : Any]? {
        
        let bodyParams = """
        {
            carParks {
                name
                maxCapacity
                spacesAvailable
                lat
                lon
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
