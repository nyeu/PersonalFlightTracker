//
//  LocationManager.swift
//  PersonalFlightTracker
//
//  Created by Joan on 24/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationUpdated(locations: [CLLocation])
}

enum LocationState {
    case stop
    case record
}
class LocationManager: NSObject  {
    let locationManager = CLLocationManager()
    var knownLocations: [CLLocation] = []
    var state: LocationState = .stop
    weak var delegate: LocationManagerDelegate?
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }


}

extension LocationManager: CLLocationManagerDelegate  {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard state == .record else {
            if knownLocations.count == 0 {
                knownLocations = knownLocations + locations
                self.delegate?.locationUpdated(locations: knownLocations)
            }
            return
        }
        print(locations)
        knownLocations = knownLocations + locations
        self.delegate?.locationUpdated(locations: knownLocations)
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }

    func inKilometers() -> CLLocationDistance {
        return self/1000
    }

    func inFeet() -> CLLocationDistance {
        let oneFeetPerMeter = 3.28084
        return self*oneFeetPerMeter
    }
}
