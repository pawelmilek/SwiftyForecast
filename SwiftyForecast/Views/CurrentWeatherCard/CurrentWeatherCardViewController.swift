//
//  CurrentWeatherCardViewController.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

final class CurrentWeatherCardViewController: UIViewController {
    private let viewModel = CurrentWeatherCard.ViewModel()
    private var hostingViewController: UIHostingController<CurrentWeatherCard>!

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func reloadCurrentLocation() {
        viewModel.reloadCurrentLocation()
    }

    func loadData(at location: LocationModel) {
        viewModel.loadData(at: location)
    }

    private func setup() {
        let currentWeatherCard = CurrentWeatherCard(viewModel: viewModel)
        hostingViewController = UIHostingController(rootView: currentWeatherCard)
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
    }

    private func setupAutolayoutConstraints() {
        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    deinit {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }
}
