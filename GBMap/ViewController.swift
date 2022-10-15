//
//  ViewController.swift
//  GBMap
//
//  Created by Pavel Kruchinin on 13.10.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

final class ViewController: UIViewController {
    
    private let mapView: GMSMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(GMSMapView())
    
    private var markers: [GMSMarker] = []
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureLocationManager()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    private func goTo(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    private func addMarker(_ coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        self.markers.append(marker)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        addMarker(coordinate)
        goTo(coordinate)
    }
}
