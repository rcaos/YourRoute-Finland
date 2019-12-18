//
//  MainGMapView.swift
//  YourRoute
//
//  Created by Jeans on 12/17/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import GoogleMaps

class GoogleMapView: MainMapView {
    
    override var viewModel: MainMapViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView(frame: .zero)
//        mapView.mapType = .normal
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//        mapView.isRotateEnabled = false
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
        
        //mapView.register(LegAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //mapView.delegate = self
        
        setDefaultRegion()
    }
    
    func setDefaultRegion() {
        // MARK: - TODO
        // Default Location debería estar en el ViewMODEL
        
        let location = CLLocation(latitude: 60.1706, longitude: 24.9375)
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
    }
    
    func setupViewModel() {
        viewModel?.viewState.bindAndFire({ [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.configView(with: state)
        })
    }
    
    func configView(with state: MainMapViewModel.ViewState) {
        switch state {
        case .initial:
            cleanMapView()
        case .empty, .populated:
            setupMapViewElements()
        }
    }
    
    func cleanMapView() {
        //mapView.removeAnnotations( mapView.annotations )
        //mapView.removeOverlays( mapView.overlays )
    }
    
    func setupMapViewElements() {
        setupAnnotations()
        setupRoutes()
        
        //centerAnnotations()
    }
    
    func setupAnnotations() {
//        mapView.removeAnnotations( mapView.annotations )
//
//        guard let places = viewModel?.places else { return }
//        mapView.addAnnotations( places )
    }
    
    func setupRoutes() {
//        mapView.removeOverlays( mapView.overlays )
//
//        guard let routes = viewModel?.routes else { return }
//        for (type,route) in routes {
//            let line = CustomMKPolyline(coordinates: route, count: route.count)
//            line.type = type
//            mapView.addOverlay(line)
//        }
    }
}

//MARK: - MKMapViewDelegate TODO

//extension MainGMapView: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let customPolyLine = overlay as? CustomMKPolyline {
//            let polyLine = MKPolylineRenderer(overlay: overlay)
//
//            polyLine.strokeColor = customPolyLine.color
//            polyLine.lineWidth = customPolyLine.width
//            polyLine.lineDashPattern = customPolyLine.dashPatter
//
//            return polyLine
//        }
//
//        return MKPolylineRenderer()
//    }
//}

//MARK: - Center Map

//extension GoogleMapView {
//
//    fileprivate func centerAnnotations() {
//        guard let _ = viewModel?.places else { return }
//        let (topLeftCoord, bottomRightCoord) = calculateEdgeCorners()
//
//        let center = CLLocationCoordinate2D(latitude:
//            topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
//                                            longitude:
//            topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2 )

        //MARK: - TODO
        //Depend of the State
        //Loading = 1.5
        //Populated, hay más espacio Top, maybe 1.2?
        //let extraSpace = 1.5
        
//        let span = MKCoordinateSpan(latitudeDelta:
//            abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace
//            , longitudeDelta:
//            abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
//
//        let region = MKCoordinateRegion(center: center, span: span)
//
//        mapView.setRegion(region, animated: true)
//    }
//
//    fileprivate func calculateEdgeCorners() -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
//        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
//        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
//
//        if let places = viewModel?.places {
//            for annotation in places {
//                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
//                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
//                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
//                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
//            }
//        }
//
//        return (topLeftCoord, bottomRightCoord)
//    }
//}
