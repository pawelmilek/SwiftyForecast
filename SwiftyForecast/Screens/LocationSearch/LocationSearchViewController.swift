//
//  LocationSearchViewController.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/23/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

class LocationSearchViewController: UIViewController {
    private let viewModel = LocationSearchView.ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationSearchView = LocationSearchView(viewModel: viewModel)
        let hostingViewController = UIHostingController(rootView: locationSearchView)
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        add(hostingViewController)

        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

#Preview {
    LocationSearchViewController()
}
