//
//  LocationSearchViewController.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

protocol LocationSearchViewControllerDelegate: AnyObject {
    func locationListViewController(
        _ view: LocationSearchViewController,
        didSelectLocation location: LocationModel
    )
}

final class LocationSearchViewController: UIViewController {
    weak var delegate: LocationSearchViewControllerDelegate?
    private var hostingViewController: UIHostingController<LocationSearchView>!
    private weak var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let locationSearchView = LocationSearchView { [weak self] selectedLocation in
            guard let self else { return }
            delegate?.locationListViewController(
                self,
                didSelectLocation: selectedLocation
            )
        }

        hostingViewController = UIHostingController(rootView: locationSearchView)
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

#Preview {
    LocationSearchViewController(coordinator: MainCoordinator(navigationController: .init()))
}
