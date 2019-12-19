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
        
        // MARK: - TODO, check other defaults configurations
//        mapView.mapType = .normal
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//        mapView.isRotateEnabled = false
        
        return mapView
    }()
    
    var markers: [GMSMarker] = []
    
    var routes: [GMSPolyline] = []
    
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
        setDefaultRegion()
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: topAnchor),
                                     mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     mapView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func setDefaultRegion() {
        // MARK: - TODO
        // Default Location should be in ViewMODEL, DataSource?
        
        let location = CLLocation(latitude: 60.1706, longitude: 24.9375)
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
    }
    
    private func setupViewModel() {
        viewModel?.viewState.bindAndFire({ [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.configView(with: state)
        })
    }
    
    private func configView(with state: MainMapViewModel.ViewState) {
        switch state {
        case .initial, .empty:
            cleanMapView()
        case .populated:
            setupMapViewElements()
        }
    }
    
    private func cleanMapView() {
        mapView.clear()
    }
    
    private func setupMapViewElements() {
        setupAnnotations()
        setupRoutes()
        centerAnnotations()
    }
    
    private func setupAnnotations() {
        cleanMarkers()
        guard let places = viewModel?.places else { return }
        
        for place in places {
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.title = place.place.name
            marker.map = self.mapView
            marker.zIndex = 0
            
            if let typeMarker = place.typePlace {
                switch typeMarker {
                case .origin:
                    marker.icon = GMSMarker.markerImage(with: UIColor(red: 25/255, green: 175/255, blue: 51/255, alpha: 1.0))
                    marker.zIndex = 1
                    
                case .busStation:
                    marker.icon = GMSMarker.markerImage(with: UIColor(red: 4/255, green: 166/255, blue: 255/255, alpha: 1.0))
                    
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                    imageView.backgroundColor = UIColor(red: 4/255, green: 166/255, blue: 255/255, alpha: 1.0)
                    imageView.image = UIImage(named: "busPlaceMark")
                    marker.iconView = imageView
                
                case .destination:
                    marker.zIndex = 1
                    
                case .unknown:
                    marker.icon = GMSMarker.markerImage(with: nil)
                }
            }
            
            markers.append( marker )
        }
    }
    
    private func setupRoutes() {
        cleanRoutes()
        guard let routesModel = viewModel?.routesGoogle else { return }
        
        for (type, encodedRoute) in routesModel {
            let route = drawRoute(type, from: encodedRoute)
            routes.append( route )
        }
    }
    
    private func drawRoute(_ type: LegMode, from polyStr: String) -> GMSPolyline {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        
        switch type {
        case .WALK:
            polyline.strokeWidth = 3.0
            polyline.strokeColor = UIColor.green
        case .BUS:
            polyline.strokeWidth = 3.0
            polyline.strokeColor = UIColor.blue
        }
        
        return polyline
    }
    
    private func cleanMarkers() {
        for marker in markers {
            marker.map  = nil
        }
        markers.removeAll()
    }
    
    private func cleanRoutes() {
        for route in routes {
            route.map = nil
        }
        routes.removeAll()
    }
    
    // MARK: - Center Map
    
    private func centerAnnotations() {
        guard let firstLocation = markers.first else { return }
        
        let firstPosition = firstLocation.position
        
        var bounds = GMSCoordinateBounds(coordinate: firstPosition, coordinate: firstPosition)
        
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let newCamera = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(15))
        self.mapView.animate(with: newCamera)
    }
}
