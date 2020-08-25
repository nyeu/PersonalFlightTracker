//
//  LocationManager.swift
//  PersonalFlightTracker
//
//  Created by Joan on 24/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

typealias Altitude = (pressure: Float, relativeAltitude: Float)
protocol LocationManagerDelegate: class {
    func locationUpdated(locations: [CLLocation], altitudes: [Altitude])
}

enum LocationState {
    case stop
    case record
}
class LocationManager: NSObject  {
    let locationManager = CLLocationManager()
    let barometerAltitude = CMAltimeter()
    var knownLocations: [CLLocation] = []
    var knownAltitudes: [Altitude] = []

    var waypoints: [Waypoint] = []

    var state: LocationState = .stop



    weak var delegate: LocationManagerDelegate?
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        barometerAltitude.startRelativeAltitudeUpdates(to: OperationQueue.main) { (altitudeData, error) in
            guard error == nil else {
                return
            }
            print(String(format: "%.1fM", (altitudeData?.relativeAltitude.floatValue)!))
            print(String(format: "%.2f hPA", (altitudeData?.pressure.floatValue)!*10))
            let altitude = Altitude((altitudeData?.pressure.floatValue)!*10, (altitudeData?.relativeAltitude.floatValue)!)

            if let lastLocation = self.knownLocations.last {
                let wayPoint = Waypoint(coordinate: Coordinate(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude), altitude: Double(altitude.relativeAltitude))
                self.waypoints.append(wayPoint)
            }

            self.knownAltitudes.append(altitude)
            self.delegate?.locationUpdated(locations: self.knownLocations, altitudes: self.knownAltitudes)
          }
    }
}

extension LocationManager: CLLocationManagerDelegate  {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard state == .record else {
            if knownLocations.count == 0 {
                knownLocations = knownLocations + locations
                self.delegate?.locationUpdated(locations: knownLocations, altitudes: knownAltitudes)

                if let lastAltitude = self.knownAltitudes.last, let lastLocation = locations.last {
                    let wayPoint = Waypoint(coordinate: Coordinate(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude), altitude: Double(lastAltitude.relativeAltitude))
                    self.waypoints.append(wayPoint)
                }
            }
            return
        }
        knownLocations = knownLocations + locations
        if let lastAltitude = self.knownAltitudes.last, let lastLocation = locations.last {
            let wayPoint = Waypoint(coordinate: Coordinate(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude), altitude: Double(lastAltitude.relativeAltitude))
            self.waypoints.append(wayPoint)
        }
        self.delegate?.locationUpdated(locations: knownLocations, altitudes: knownAltitudes)
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

extension Float {
    func inMiles() -> Float {
        return self*0.00062137
    }

    func inKilometers() -> Float {
        return self/1000
    }

    func inFeet() -> Float {
        let oneFeetPerMeter: Float = 3.28084
        return self*oneFeetPerMeter
    }
}
