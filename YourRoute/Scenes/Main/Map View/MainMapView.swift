//
//  MainMapView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import MapKit

class MainMapView: UIView {
    
    var viewModel: MainMapViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = MKMapType.standard
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
        return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        backgroundColor = .white
        setupMapView()
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: topAnchor),
                                     mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     mapView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        mapView.register(LegAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.delegate = self
    }
    
    func setDefaultRegion() {
        let centerLocation = CLLocation(latitude: 60.1706, longitude: 24.9375)
        let regionRadius: CLLocationDistance = 10000.0
        let region = MKCoordinateRegion(center: centerLocation.coordinate,
                                        latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func setupViewModel() {
        viewModel?.updateAnnotations = { [weak self] in
            self?.setupAnnotations()
        }
    }
    
    func setupAnnotations() {
        guard let viewModel = viewModel else { return }
        
        //Check first Correct Annotations
        mapView.addAnnotations( viewModel.places )
        drawRoutes()
        centerAnnotations()
    }
    
    func centerAnnotations() {
        guard let _ = viewModel?.places else { return }
        let (topLeftCoord, bottomRightCoord) = calculateEdgeCorners()
        
        let center = CLLocationCoordinate2D(latitude:
            topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
                                            longitude:
            topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2 )
        
        let extraSpace = 1.3
        let span = MKCoordinateSpan(latitudeDelta:
            abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace
            , longitudeDelta:
            abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func calculateEdgeCorners() -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        if let places = viewModel?.places {
            for annotation in places {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
        }
        
        return (topLeftCoord, bottomRightCoord)
    }
    
    //MARK: - Draw Routes
    
    func drawRoutes() {
        guard let routes = viewModel?.routes else { return }
        
        for (type,route) in routes {
            let line = CustomMKPolyline(coordinates: route, count: route.count)
            line.type = type
            mapView.addOverlay(line)
        }
        
    }
}

//MARK: - MKMapViewDelegate

extension MainMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let customPolyLine = overlay as? CustomMKPolyline {
            let polyLine = MKPolylineRenderer(overlay: overlay)
            
            polyLine.strokeColor = customPolyLine.color
            polyLine.lineWidth = customPolyLine.width
            polyLine.lineDashPattern = customPolyLine.dashPatter
            
            return polyLine
        }
        
        return MKPolylineRenderer()
    }
}
