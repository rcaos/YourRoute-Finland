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
        
//        switch source {
//        case .apple:
//            dataSource = SearchPlacesAppleDataSource()
//        case .google:
//            configGoogleMapsService()
//            dataSource = SearchPlacesGoogleDataSource()
//        }
        
        configGoogleMapsService()
        dataSource = SearchPlacesGoogleDataSource()
        
        setupMainController(with: dataSource)
    }
    
    // MARK: - Private
    
    private func configGoogleMapsService() {
        //let googleApiKey = "AIzaSyBw9Rd2T5LpnkdIa0jF_Ud58vPNqVsD828"
        
        //Please put your api Keys here
        
        let mapAPIKey = "AIzaSyDRNvDotxs0oR4rP7-Eid62XD9WLcDU2Mw"
        let placesAPIKey = "AIzaSyDRNvDotxs0oR4rP7-Eid62XD9WLcDU2Mw"
        
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

