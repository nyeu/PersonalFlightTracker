//
//  RoutesViewController.swift
//  PersonalFlightTracker
//
//  Created by Joan on 25/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import Foundation
import UIKit

class RoutesViewController: UIViewController {
    let dataModel = DataModel.shared
    var routes: [Route]

    private let tableView: UITableView = {
        let t = UITableView()
        t.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return t
    }()

    let playButton: UIButton = {
        let b = UIButton()
        b.setTitle("Start Recording", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 6.0
        return b
    }()


    init() {
        routes = dataModel.routes()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
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
        view.backgroundColor = .white
//        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.kIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        playButton.addTarget(self, action: #selector(startPlaying), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routes = dataModel.routes()
        tableView.reloadData()
    }

    @objc func startPlaying() {
        let map = MapViewController()
        present(map, animated: true, completion: nil)
    }
}

extension RoutesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")//tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.kIdentifier, for: indexPath) as? HomeTableViewCell ?? HomeTableViewCell()
        let route = routes[indexPath.row]
        cell.textLabel?.text = route.date.description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes[indexPath.row]
        let replay = ReplayMapViewController(route: route)
        present(replay, animated: true, completion: nil)
//        let category = categoryService.categories[indexPath.row]
//        let generalViewModel = GeneralExamViewModel(category: category)
//        let generalViewController = GeneralExamViewController(viewModel: generalViewModel)
//        self.navigationController?.pushViewController(generalViewController, animated: true)
    }
}
