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
    func locationSearchViewController(
        _ view: LocationSearchViewController,
        didSelectLocation index: Int
    )
}

final class LocationSearchViewController: UIViewController {
    weak var delegate: LocationSearchViewControllerDelegate?
    private var hostingViewController: UIHostingController<FavoriteLocationSearchView>!
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

        let locationSearchView = FavoriteLocationSearchView { [weak self] selectedIndex in
            guard let self else { return }
            delegate?.locationSearchViewController(self,didSelectLocation: selectedIndex)
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
    LocationSearchViewController(
        coordinator: MainCoordinator(
            navigationController: .init(),
            databaseManager: PreviewRealmManager()
        )
    )
}
