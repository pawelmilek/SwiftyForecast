//
//  MainViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import TipKit
import Combine

final class MainViewController: UIViewController {
    @AppStorage("appearanceTheme") var theme: Theme = .systemDefault

    private lazy var aboutBarButton: UIBarButtonItem = {
        aboutBarButtonItem()
    }()

    private lazy var themeBarButton: UIBarButtonItem = {
        themeBarButtonItem()
    }()

    private lazy var locationBarButton: UIBarButtonItem = {
        locationBarButtonItem()
    }()

    private lazy var notationSegmentedControl: UISegmentedControl = {
        segmentedControl()
    }()

    private let pageViewController = MainPageViewController(
        currentIndex: 0,
        feedbackGenerator: UIImpactFeedbackGenerator(style: .light)
    )

    private let informationTip = InformationTip()
    private let themeTip = ThemeTip()

    private var informationTipObservationTask: Task<Void, Never>?
    private weak var informationTipPopoverController: TipUIPopoverViewController?
    private var themeTipObservationTask: Task<Void, Never>?
    private weak var themeTipPopoverController: TipUIPopoverViewController?
    private var cancellables = Set<AnyCancellable>()

    weak var coordinator: Coordinator?
    var viewModel: MainViewControllerViewModel

    init?(
        viewModel: MainViewControllerViewModel,
        coordinator: Coordinator,
        coder: NSCoder
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(viewModel:coordinator:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTipObservationTasks()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTipObservationTasks()
    }
}

// MARK: - Private - SetUps
private extension MainViewController {

    func setup() {
        subscribePublishers()
        setupChildPageViewController()
        setupNavigationItems()
        setupPageControlAppearance()
    }

    func subscribePublishers() {
        viewModel.$notationControlIndex
            .assign(to: \.selectedSegmentIndex, on: notationSegmentedControl)
            .store(in: &cancellables)

        viewModel.$locations
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .map { locations -> [WeatherViewController] in
                locations.map {
                    CompositionRoot.weatherViewController(
                        compoundKey: $0.compoundKey,
                        latitude: $0.latitude,
                        longitude: $0.longitude,
                        name: $0.name
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewControllers in
                self?.pageViewController.set(viewControllers)
                self?.selectInitialPageViewController()
            }
            .store(in: &cancellables)

        viewModel.$selectedIndex
            .dropFirst()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedIndex in
                self?.pageTransition(at: selectedIndex)
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.requestLocation()
                self?.setupTheme()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .didChangeTheme)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupTheme()
            }
            .store(in: &cancellables)

        viewModel.$hasNetworkConnection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasNetworkConnection in
                if hasNetworkConnection {
                    self?.coordinator?.dismissOfflineView()
                } else {
                    self?.coordinator?.presentOfflineView()
                }
            }
            .store(in: &cancellables)
    }

    func setupTheme() {
        let window = Array(UIApplication.shared.connectedScenes)
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })

        switch theme {
        case .dark:
            window?.overrideUserInterfaceStyle = .dark

        case .light:
            window?.overrideUserInterfaceStyle = .light

        case .systemDefault:
            window?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        }
    }

    func selectInitialPageViewController() {
        viewModel.onSelectIndex(0)
    }

    func setupNavigationItems() {
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        setupNotationSystemSegmentedControl()
    }

    func setupLeftBarButtonItem() {
        navigationItem.leftBarButtonItems = [aboutBarButton, themeBarButton]
    }

    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = locationBarButton
    }

    func setupNotationSystemSegmentedControl() {
        navigationItem.titleView = notationSegmentedControl
    }

    func setupChildPageViewController() {
        add(pageViewController)
    }

    func setupPageControlAppearance() {
        let proxyPageControl = UIPageControl.appearance()
        proxyPageControl.pageIndicatorTintColor = Style.Main.pageIndicatorTintColor
        proxyPageControl.currentPageIndicatorTintColor = .customPrimary
        view.backgroundColor = Style.Main.backgroundColor
    }

    func setupTipObservationTasks() {
        setInformationTipObservationTask()
        setThemeTipObservationTask()
    }

    func setInformationTipObservationTask() {
        informationTipObservationTask = informationTipObservationTask ?? Task { @MainActor in
            for await shouldDisplay in informationTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let popoverController = TipUIPopoverViewController(
                        informationTip,
                        sourceItem: aboutBarButton
                    )
                    popoverController.view.tintColor = .customPrimary
                    present(popoverController, animated: true)
                    informationTipPopoverController = popoverController
                } else {
                    if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                        informationTipPopoverController = nil
                    }
                }
            }
        }
    }

    func setThemeTipObservationTask() {
        themeTipObservationTask = themeTipObservationTask ?? Task { @MainActor in
            for await shouldDisplay in themeTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let popoverController = TipUIPopoverViewController(
                        themeTip,
                        sourceItem: themeBarButton
                    )
                    popoverController.view.tintColor = .customPrimary
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.present(popoverController, animated: true)
                        self.themeTipPopoverController = popoverController
                    }
                } else {
                    if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                        themeTipPopoverController = nil
                    }
                }
            }
        }
    }

    func stopTipObservationTasks() {
        informationTipObservationTask?.cancel()
        informationTipObservationTask = nil
        themeTipObservationTask?.cancel()
        themeTipObservationTask = nil
    }

    private func pageTransition(at index: Int) {
        pageViewController.transition(at: index)
    }
}

// MARK: - Private - Navigation bar button items
private extension MainViewController {
    func aboutBarButtonItem() -> UIBarButtonItem {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "info")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.coordinator?.openAbout()
        })

        return UIBarButtonItem(customView: button)
    }

    func themeBarButtonItem() -> UIBarButtonItem {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "paintpalette.fill")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.coordinator?.openTheme()
        })
        return UIBarButtonItem(customView: button)
    }

    func locationBarButtonItem() -> UIBarButtonItem {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "location.fill")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.coordinator?.openLocations()
        })
        return UIBarButtonItem(customView: button)
    }

    func segmentedControl() -> UISegmentedControl {
        let control = UISegmentedControl(items: viewModel.notationControlItems)
        control.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        control.addAction( UIAction { [weak self] action in
            guard let sender = action.sender as? UISegmentedControl else { return }
            self?.viewModel.onSegmentedControlDidChange(sender.selectedSegmentIndex)
            UIImpactFeedbackGenerator().impactOccurred()
        }, for: .valueChanged)

        return control
    }
}

// MARK: - LocationListSelectionViewControllerDelegate
extension MainViewController: LocationSearchViewControllerDelegate {
    func locationSearchViewController(
        _ view: LocationSearchViewController,
        didSelectLocation index: Int
    ) {
        viewModel.onSelectIndex(index)
        coordinator?.dismiss()
    }

}
