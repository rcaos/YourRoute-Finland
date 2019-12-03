//
//  CarParksClient.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class CarParksClient: ApiClient {
    
    let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    //MARK: - Get All CarParks
    
    func getAll(completion: @escaping(Result<CarParkResult?,APIError>) -> Void ) {
        let request = CarParkProvider.getAllCarParks.request
        
        fetch(with: request,
              decode: { json -> CarParkResult? in
                guard let result = json as? CarParkResult else { return nil }
                return result
        },completion: completion)
    }
}
