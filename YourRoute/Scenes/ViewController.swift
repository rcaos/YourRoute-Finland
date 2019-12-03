//
//  ViewController.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
 
    var viewModel = ViewModel()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupBindables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getParkings()
    }
    
    func setupMap() {
        setupMapView()
        setupMapData()
    }
    
    func setupMapView() {
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = false
        mapView.showsBuildings = true
        mapView.showsScale = false
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = false
        
        mapView.isScrollEnabled = true
        //TODO: 3Dview property?
        mapView.showsCompass = true
        mapView.showsTraffic = false
    }
    
    func setupMapData() {
        mapView.delegate = self
        
        guard let centerLocation = viewModel.currentLocation else { return }
        let regionRadius: CLLocationDistance = 4000.0
        let region = MKCoordinateRegion(center: centerLocation.coordinate,
                                        latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func setupBindables() {
        viewModel.reloadAnnotations = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadAnnotations()
            }
        }
    }
    
    func reloadAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.annotations)
        
        centerAnnotations()
    }
    
    func centerAnnotations() {
        let (topLeftCoord, bottomRightCoord) = calculateEdgeCorners()
        
        let center = CLLocationCoordinate2D(latitude:
            topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
                                            longitude:
            topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2 )
        
        let extraSpace = 1.2
        let span = MKCoordinateSpan(latitudeDelta:
            abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace
            , longitudeDelta:
            abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func calculateEdgeCorners() -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in viewModel.annotations {
            topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
            topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
        }
        
        return (topLeftCoord, bottomRightCoord)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if let _ = annotation as? CarParkAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CarParkAnnotation") as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CarParkAnnotation")
                //annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            //🚗
            annotationView?.glyphText = "🚕"
            annotationView?.markerTintColor = UIColor.red
            
            return annotationView
        }
        
        return nil
    }
}
