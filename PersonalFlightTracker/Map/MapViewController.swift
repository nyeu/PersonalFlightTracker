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

class MapViewController: UIViewController {
    let mapView: MKMapView

    init() {
        mapView = MKMapView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        view.addSubview(mapView)

        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }


}
