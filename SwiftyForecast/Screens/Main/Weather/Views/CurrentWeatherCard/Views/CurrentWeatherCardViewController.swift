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
    private var hostingViewController: UIHostingController<CurrentWeatherCard>!
    private let viewModel: CurrentWeatherCardViewModel

    init(viewModel: CurrentWeatherCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
