//
//  Route.swift
//  PersonalFlightTracker
//
//  Created by Joan on 25/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation

struct Route: Codable {
    let date: Date
    let waypoints: [Waypoint]

    init(waypoints: [Waypoint]) {
        self.waypoints = waypoints
        self.date = Date()
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        waypoints = try container.decode([Waypoint].self, forKey: .waypoints)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(waypoints, forKey: .waypoints)
    }
}

extension Route {
    fileprivate enum CodingKeys: String, CodingKey {
        case date
        case waypoints
    }
}
