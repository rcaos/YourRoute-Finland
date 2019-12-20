//
//  SearchPlacesDataSource.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum DataSourceType {
    case apple
    case google
}

protocol SearchPlacesDataSource {
    
    var defaultLocation: TypeLocation { get set }
    
    var resultPlaces: [ResultPlace] { get }
    
    var typeSource: DataSourceType { get set }
    
    func search(with text: String, completion: @escaping(Result<[ResultPlace], APIError>) -> Void )
    
    func fetchDetails(for origin: ResultPlace, destination: ResultPlace,
                       completion: @escaping(
        Result<(origin: ResultPlace, destination: ResultPlace),APIError>) -> Void )
}

extension SearchPlacesDataSource {
    
    func fetchDetails(for origin: ResultPlace, destination: ResultPlace,
                      completion: @escaping(
        Result<(origin: ResultPlace, destination: ResultPlace),APIError>) -> Void ) {
        //only for google Maps
        //for mapKit: Thanks but no thanks
    }
}
