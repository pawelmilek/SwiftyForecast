//
//  ThemeViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

public final class ThemeViewController: UIViewController {
    weak var coordinator: Coordinator?
    private let viewModel: ThemeViewModel
    private let textColor: Color
    private let darkScheme: Color
    private let lightScheme: Color
    private var hostingViewController: UIHostingController<ThemeView>!

    init(
        viewModel: ThemeViewModel,
        textColor: Color,
        darkScheme: Color,
        lightScheme: Color,
        coordinator: Coordinator
    ) {
        self.viewModel = viewModel
        self.textColor = textColor
        self.darkScheme = darkScheme
        self.lightScheme = lightScheme
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let appearanceView = ThemeView(
            viewModel: viewModel,
            textColor: textColor,
            darkScheme: darkScheme,
            lightScheme: lightScheme
        )
        hostingViewController = UIHostingController(rootView: appearanceView)
        hostingViewController.view.backgroundColor = .clear
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
        setupSheetPresentation()
    }

    private func setupSheetPresentation() {
        if let sheet = presentationController as? UISheetPresentationController {
            sheet.detents = [.custom(resolver: { [weak self] _ in self?.viewModel.height })]
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
