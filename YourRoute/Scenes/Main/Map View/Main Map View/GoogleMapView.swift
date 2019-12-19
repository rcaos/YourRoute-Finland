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
    
    var markers: [GMSMarker] = []
    
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
            print("change map to initial")
            cleanMapView()
        case .empty, .populated:
            print("change map empty, populated")
            setupMapViewElements()
        }
    }
    
    func cleanMapView() {
        mapView.clear()
        
        //mapView.removeOverlays( mapView.overlays )
    }
    
    func setupMapViewElements() {
        setupAnnotations()
        setupRoutes()
        
        centerAnnotations()
    }
    
    func setupAnnotations() {
        guard let places = viewModel?.places else { return }

        //Clearn only Markers
        for marker in markers {
            marker.map  = nil
        }
        markers.removeAll()
        
        for place in places {
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.title = place.place.name
            marker.map = self.mapView
            
            if let typeMarker = place.typePlace {
                switch typeMarker {
                case .origin:
                    marker.icon = GMSMarker.markerImage(with: UIColor(red: 25/255, green: 175/255, blue: 51/255, alpha: 1.0))
                case .busStation:
                    marker.icon = GMSMarker.markerImage(with: UIColor(red: 4/255, green: 166/255, blue: 255/255, alpha: 1.0))
                case .destination, .unknown:
                    marker.icon = GMSMarker.markerImage(with: nil)
                }
            }
            
            markers.append( marker )
        }
        
        print("add markers: \(markers.count)")
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
    
    // MARK: - Center Map
    
    fileprivate func centerAnnotations() {
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
