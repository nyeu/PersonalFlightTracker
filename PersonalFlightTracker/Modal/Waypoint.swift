//
//  Waypoint.swift
//  PersonalFlightTracker
//
//  Created by Joan on 25/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}

struct Waypoint: Codable {
    let coordinate: Coordinate
    let altitude: Double

    init(coordinate: Coordinate, altitude: Double) {
        self.coordinate = coordinate
        self.altitude = altitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        altitude = try container.decode(Double.self, forKey: .altitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(altitude, forKey: .altitude)
    }
}

extension Waypoint {
    fileprivate enum CodingKeys: String, CodingKey {
        case coordinate
        case altitude
    }
}
