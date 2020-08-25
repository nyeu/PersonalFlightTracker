//
//  ReplayMapViewController.swift
//  PersonalFlightTracker
//
//  Created by Joan on 25/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import CoreLocation

class ReplayMapViewController: UIViewController {
    let mapView: MKMapView
    let route: Route
    let playButton: UIButton = {
        let b = UIButton()
        b.setTitle("Start Playing", for: .normal)
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
        l.numberOfLines = 0
        return l
    }()

    var timer: Timer?
    var index: Int = 0

    init(route: Route) {
        self.route = route
        mapView = MKMapView(frame: .zero)

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
            make.top.equalToSuperview().offset(50)
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
        mapView.showsUserLocation = false
        mapView.delegate = self
        playButton.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
    }

    @objc func startPlaying() {
        guard index < self.route.waypoints.count else {
            dismiss(animated: true, completion: nil)
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateWaypoint), userInfo: nil, repeats: true)
        playButton.isHidden = true
    }

    @objc func updateWaypoint() {
        guard index < self.route.waypoints.count else {
            playButton.isHidden = false
            playButton.setTitle("Close", for: .normal)
            return
        }
        self.newWayPoint(wayPoint: self.route.waypoints[index])
        index += 1
    }
}

extension ReplayMapViewController {
    func newWayPoint(wayPoint: Waypoint) {
        let coordinate = CLLocationCoordinate2D(latitude: wayPoint.coordinate.latitude, longitude: wayPoint.coordinate.longitude)
        altitudeLabel.text = "Altitude: \(String(format: "%.2f", wayPoint.altitude.inFeet()))"
        mapView.setCenter(coordinate, animated: true)
        addOverlays(coordinates: [coordinate])
    }
}

extension ReplayMapViewController: MKMapViewDelegate {
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
