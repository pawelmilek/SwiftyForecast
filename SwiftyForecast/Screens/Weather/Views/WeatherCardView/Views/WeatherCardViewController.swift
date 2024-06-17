//
//  WeatherCardViewController.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class WeatherCardViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private var hostingViewController: UIHostingController<WeatherCardView>!
    private let viewModel: WeatherCardViewViewModel

    init(viewModel: WeatherCardViewViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWeatherData()
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }

    private func setup() {
        let currentWeatherCard = WeatherCardView(viewModel: viewModel)
        hostingViewController = UIHostingController(rootView: currentWeatherCard)
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        add(hostingViewController)
        setupAutolayoutConstraints()
        subscribePublishers()
    }

    private func subscribePublishers() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadWeatherData()
            }
            .store(in: &cancellables)
    }

    func loadWeatherData() {
        Task {
            await viewModel.loadData()
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
