//
//  EndPoint.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

//TODO: - implement "ParameterEncoding" -
//FIXME: - implement POST http method

import Foundation

protocol EndPoint {
    
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var method: HTTPMethod { get }
}

extension EndPoint {

    var urlComponents: URLComponents {
        var components = URLComponents(string: baseURL)!
        components.path = path
        
        var queryItems:[URLQueryItem] = []
        
        switch parameterEncoding {
        case .defaultEncoding:
            if let params = parameters, method == .get {
                queryItems.append(contentsOf: params.map({
                    return URLQueryItem(name: "\($0)", value: "\($1)")
                }))
            }
        default:
            break
        }
        
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        guard let url = urlComponents.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        //request.setValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.setHeader(for: key, with: value)
            }
        }
        
        guard let params = parameters, method != .get else { return request }
        
        //request.httpBody
        
        switch parameterEncoding {
        case .defaultEncoding:
            request.httpBody = params.percentEscaped().data(using: .utf8)
        case .bodyDefaultEncoding:
            if let bodyParams = params["body"] as? String {
                request.httpBody = bodyParams.data(using: .utf8)
            }
        }

        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // implement more when needed: put, delete, patch, etc.
}

enum ParameterEncoding {
    case defaultEncoding
    case bodyDefaultEncoding
    
    //MARK: - TODO others encodings
    
    //case jsonEncoding
    //case compositeEncoding
}
