//
//  MapViewController.swift
//  PersonalFlightTracker
//
//  Created by Joan on 24/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    let mapView: MKMapView
    let locationManager: LocationManager
    let playButton: UIButton = {
        let b = UIButton()
        b.setTitle("Start Recording", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 6.0
        return b
    }()

    let altitudeLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .white
        l.textColor = .systemBlue
        l.textAlignment = .center
        return l
    }()

    init() {
        mapView = MKMapView(frame: .zero)
        
        locationManager = LocationManager()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(mapView)

        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        view.addSubview(altitudeLabel)
        altitudeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        playButton.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
    }

    @objc func startPlaying() {
        locationManager.state = .record
    }
}

extension MapViewController: LocationManagerDelegate {
    func locationUpdated(locations: [CLLocation]) {
        if let lastLocation = locations.last, let coordinate = locations.last?.coordinate {
            mapView.setCenter(coordinate, animated: true)
            mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1)), animated: true)
            altitudeLabel.text = "Altitude: \(lastLocation.altitude)"
        }
        addOverlays(coordinates: locations.map({$0.coordinate}))
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {

    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
        return renderer
    }

    fileprivate func addOverlays(coordinates: [CLLocationCoordinate2D]) {
        let p = MKPolygon(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(p)
        }

}
