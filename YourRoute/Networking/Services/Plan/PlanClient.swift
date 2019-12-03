//
//  PlanClient.swift
//  YourRoute
//
//  Created by Jeans on 12/3/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class PlanClient: ApiClient {
    
    let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    //MARK: - Get Plan
    
    func getPlan(origin: (latitude: Double, longitude: Double),
                 destination: (latitude: Double, longitude: Double),
                 completion: @escaping(Result<PlanResult?, APIError>) -> Void) {
        
        let request = PlanProvider.getPlan(origin.latitude, origin.longitude,
                                           destination.latitude, destination.longitude).request
        
        fetch(with: request,
              decode: { json -> PlanResult? in
                guard let result = json as? PlanResult else { return nil }
                return result
        }, completion: completion)
    }
}
