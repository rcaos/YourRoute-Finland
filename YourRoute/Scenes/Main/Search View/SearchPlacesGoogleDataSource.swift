//
//  SearchPlacesGoogleDataSource.swift
//  YourRoute
//
//  Created by Jeans on 12/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import GooglePlaces

class SearchPlacesGoogleDataSource: SearchPlacesDataSource {
    
    var defaultLocation: TypeLocation = {
        //Helsinki
        let place = ResultPlace(name: "", latitude: 60.1706, longitude: 24.9375)
        return .defaultLocation(place)
    }()
    
    private var resultGooglePlaces : [GMSAutocompletePrediction] = []
    
    var resultPlaces: [ResultPlace] {
        return resultGooglePlaces.map({
            var result = ResultPlace(name: $0.attributedFullText.string, latitude: 0, longitude: 0)
            result.placeId = $0.placeID
            return result
        })
    }
    
    var typeSource: SearchDataSourceType = .google
    
    let token = GMSAutocompleteSessionToken.init()
    
    let filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment    // .address ??
        return filter
    }()
    
    
    // MARK: - Initializers
    
    init(location: TypeLocation? = nil) {
        configCenter(for: location)
    }
    
    func configCenter(for location: TypeLocation?) {
        guard let location = location else { return }
        self.defaultLocation = location
    }
    
    // MARK: - TODO, predictions near location
    // func buildRegion(for location: TypeLocation) -> MKCoordinateRegion{ }
    
    func search(with text: String, completion: @escaping(Result<[ResultPlace], APIError>) -> Void ) {
        resultGooglePlaces.removeAll()
        
        //region? , GMSCoordinateBounds
        //boundsMode: GMSAutocompleteBoundsMode.bias
        
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: text, bounds: nil,
                                                 boundsMode: GMSAutocompleteBoundsMode.bias,
                                                 filter: filter, sessionToken: token,
                                                 callback: {(results, error) in
                                                    
                                                    if let _ = error {
                                                        completion( .failure(APIError(response: nil)) )
                                                        return
                                                    }
                                                    
                                                    if let results = results {
                                                        self.resultGooglePlaces = results
                                                        completion( .success(self.resultPlaces) )
                                                    }
        })
    }
    
    
    func fetchDetails(for origin: ResultPlace, destination: ResultPlace,
                      completion: @escaping(
        Result<(origin: ResultPlace, destination: ResultPlace), APIError>) -> Void ) {
        
        guard let idOrigin = origin.placeId, let idDestination = destination.placeId else {
            completion( .failure( APIError(response: nil) ) )
            return 
        }
        
        let group = DispatchGroup()
        
        var origin: ResultPlace? = nil
        var destination: ResultPlace? = nil
        
        group.enter()
        fetchPlaceDetails(with: idOrigin, completion: { result in
            switch result {
                case .failure(_):
                    origin = nil
                case .success(let detailsPlace):
                    origin = detailsPlace
            }
            group.leave()
        })
        
        group.enter()
        fetchPlaceDetails(with: idDestination, completion: { result in
            switch result {
            case .failure(_):
                destination = nil
            case .success(let detailsPlace):
                destination  = detailsPlace
            }
            group.leave()
        })
        
        group.notify(queue: .main , execute: {
            if let origin = origin, let destination = destination {
                let resultDetailsPoints = (origin: origin, destination: destination)
                
                completion( .success( resultDetailsPoints ) )
            } else {
                completion( .failure(APIError(response: nil)) )
            }
        })
    }
    
    
    private func fetchPlaceDetails(with placeId: String, completion: @escaping(Result<ResultPlace, APIError>) -> Void ) {
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) |
                UInt(GMSPlaceField.formattedAddress.rawValue))!
        
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeId, placeFields: fields,
                                            sessionToken: nil, callback: {
                                                (place, error) in
            if let _ = error {
                completion( .failure(APIError(response: nil)) )
                return
            }
                                                
            if let customPlace = place, let name = customPlace.name {
                var resultPlace = ResultPlace(name: name ,
                                          latitude: customPlace.coordinate.latitude,
                                          longitude: customPlace.coordinate.longitude)
                resultPlace.address = customPlace.formattedAddress
                resultPlace.placeId = customPlace.placeID
                
                print("devuelvo objeto: [\(resultPlace)]")
                completion( .success(resultPlace) )
            } else {
                print("Place or  name of Place is Nil ?")
                completion( .failure(APIError(response: nil)) )
            }
        })
        
    }
}
