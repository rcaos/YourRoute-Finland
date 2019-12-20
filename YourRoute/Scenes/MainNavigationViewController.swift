//
//  MainNavigationViewController.swift
//  YourRoute
//
//  Created by Jeans on 12/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public
    
    func setDataSource(source: DataSourceType) {
        let dataSource: SearchPlacesDataSource
        
        switch source {
        case .apple:
            dataSource = SearchPlacesAppleDataSource()
        case .google:
            configGoogleMapsService()
            dataSource = SearchPlacesGoogleDataSource()
        }
        
        setupMainController(with: dataSource)
    }
    
    // MARK: - Private
    
    private func configGoogleMapsService() {
        
        // MARK: - put your Google Api KEYS here
        let mapAPIKey = ""
        let placesAPIKey = ""
        
        if mapAPIKey.isEmpty || placesAPIKey.isEmpty {
            fatalError("\nGet Google API keys for Free at: [https://developers.google.com/maps/gmp-get-started]\n\n")
        }
        
        GMSServices.provideAPIKey(mapAPIKey)
        GMSPlacesClient.provideAPIKey(placesAPIKey)
    }

    private func setupMainController(with dataSource: SearchPlacesDataSource) {
        let mainViewModel = MainViewModel(dataSource: dataSource)
        
        if let destination = viewControllers.first as? MainViewController {
            let _ = destination.view
            destination.viewModel = mainViewModel
        }
    }
}

