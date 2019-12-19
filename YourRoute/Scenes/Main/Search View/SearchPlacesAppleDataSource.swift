//
//  SearchPlacesAppleDataSource.swift
//  YourRoute
//
//  Created by Jeans on 12/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import MapKit

class SearchPlacesAppleDataSource: SearchPlacesDataSource {
    
    var defaultLocation: TypeLocation = {
        //Helsinki
        let place = ResultPlace(name: "", latitude: 60.1706, longitude: 24.9375)
        return .defaultLocation(place)
    }()
    
    var resultPlaces: [ResultPlace] = []
    
    var typeSource: DataSourceType = .apple
    
    // MARK: - Initializers
    
    init(location: TypeLocation? = nil) {
        configCenter(for: location)
    }
    
    private func configCenter(for location: TypeLocation?) {
        guard let location = location else { return }
        self.defaultLocation = location
    }
    
    func selectPlace(at index: Int) -> ResultPlace? {
        return resultPlaces[index]
    }
    
    func search(with text: String, completion: @escaping(Result<[ResultPlace], APIError>) -> Void ) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = buildRegion(for: defaultLocation)
        
        let search = MKLocalSearch(request: request)
        
        resultPlaces.removeAll()
        
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
            completion( .success(self.resultPlaces) )
        })
    }
    
    private func processFetched(with response: MKLocalSearch.Response) {
        for item in response.mapItems {
            if let name = item.placemark.name {
                resultPlaces.append(
                    ResultPlace(name: name,
                                latitude: item.placemark.coordinate.latitude,
                                longitude: item.placemark.coordinate.longitude ) )
            }
        }
    }
    
    private func buildRegion(for location: TypeLocation) -> MKCoordinateRegion{
        var center: ResultPlace
        
        switch location {
        case .defaultLocation(let place):
            center = place
        case .userLocation(let place):
            center = place
        }
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: center.coordinate.latitude ,
                                                      longitude: center.coordinate.longitude)
        let region = MKCoordinateRegion(center: centerCoordinate,
                                        latitudinalMeters: location.radius,
                                        longitudinalMeters: location.radius)
        return region
    }
    
}
