//
//  DataModel.swift
//  PersonalFlightTracker
//
//  Created by Joan on 25/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation

class DataModel {
    static let routeKey: String = "kRoute"
    static let shared: DataModel = DataModel()
    private init() {}

    func routes() -> [Route] {
        if let routesData = UserDefaults.standard.data(forKey: DataModel.routeKey),
            let routes = try? JSONDecoder().decode([Route].self, from: routesData) {
            return routes
        }
        return []
    }

    func saveRoute(_ route: Route) {
        var routes = self.routes()
        routes.append(route)
        if let encodedRoute = try? JSONEncoder().encode(routes) {
            UserDefaults.standard.set(encodedRoute, forKey: DataModel.routeKey)
        }
    }
}
