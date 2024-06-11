//
//  AboutViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

class AboutViewController: UIViewController {
    weak var coordinator: Coordinator?
    private var hostingViewController: UIHostingController<AboutScreen>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let informationView = AboutScreen()
        hostingViewController = UIHostingController(rootView: informationView)
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
        setupSheetPresentation()
    }

    private func setupSheetPresentation() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.large()]
            presentationController.prefersGrabberVisible = false
        }
        isModalInPresentation = true
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
