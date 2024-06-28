//
//  ThemeViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

final class ThemeViewController: UIViewController {
    weak var coordinator: Coordinator?
    private let viewModel: ThemeViewViewModel
    private var hostingViewController: UIHostingController<ThemeView>!

    init(viewModel: ThemeViewViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let appearanceView = ThemeView(viewModel: viewModel)
        hostingViewController = UIHostingController(rootView: appearanceView)
        hostingViewController.view.backgroundColor = .clear
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
        setupSheetPresentation()
    }

    private func setupSheetPresentation() {
        if let sheet = presentationController as? UISheetPresentationController {
            sheet.detents = [.custom(resolver: { [weak self] _ in
                self?.viewModel.height
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
