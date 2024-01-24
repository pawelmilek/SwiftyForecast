//
//  AppearanceViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

class AppearanceViewController: UIViewController {
    private var hostingViewController: UIHostingController<AppearanceView>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let appearanceView = AppearanceView {
            NotificationCenter.default.post(name: .didChangeAppearance, object: nil)
        }

        hostingViewController = UIHostingController(rootView: appearanceView)
        hostingViewController.view.backgroundColor = .clear
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
        setupSheetPresentation()
    }

    private func setupSheetPresentation() {
        if let sheet = presentationController as? UISheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return AppearanceView.Constant.height
            })]
            sheet.prefersGrabberVisible = false
        }
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
