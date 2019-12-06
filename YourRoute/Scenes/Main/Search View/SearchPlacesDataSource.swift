//
//  SearchPlacesDataSource.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

//Tendría que Borrar para el otro Source
import MapKit

//MARK: -TODO Crear un Protocol para Otro tipo de Data SOurce
//Apple vs Google Maps

struct ResultPlace {
    
    var name: String
    
    var coordinate: CLLocationCoordinate2D
    
    var address: String?

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

class SearchPlacesDataSource {
    
    
    var places: [ResultPlace] = []
    
    init() {
        
    }
    
    //Apple needs a Region?
    
    func search(with text: String, completion: @escaping(Result<[ResultPlace], APIError>) -> Void ) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: request)
        
        places.removeAll()
        
        search.start(completionHandler: { response, error in
            
            if let _ = error {
                completion( .failure( APIError(response: nil) ) )
                return
            }
            
            guard let response = response else {
                completion( .failure( APIError(response: nil) ) )
                return
            }
            
            self.processFetched(with: response)
            completion( .success(self.places) )
        })
    }
    
    private func processFetched(with response: MKLocalSearch.Response) {
        for item in response.mapItems {
            if let name = item.placemark.name {
                places.append( ResultPlace(name: name, coordinate: item.placemark.coordinate) )
            }
        }
    }
    
}
