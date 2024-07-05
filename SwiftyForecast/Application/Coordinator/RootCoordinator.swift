//
//  RootCoordinator.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation
import ThemeFeatureUI

final class RootCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.setViewControllers(
            [mainViewController],
            animated: false
        )
    }

    func openAbout() {
        navigationController.present(
            aboutViewController,
            animated: true
        )
    }

    func openTheme() {
        navigationController.present(
            themeViewController,
            animated: true
        )
    }

    func openLocations() {
        let viewController = LocationSearchViewController(coordinator: self)
        if let visibleViewController = navigationController
            .viewControllers.first(where: { $0 is LocationSearchViewControllerDelegate }) {
            viewController.delegate = visibleViewController as? LocationSearchViewControllerDelegate
        }

        navigationController.present(viewController, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    func presentOfflineView() {
        guard !navigationController.viewControllers
            .contains(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }
        navigationController.pushViewController(OfflineViewController(), animated: false)
    }

    func dismissOfflineView() {
        guard let offlineVCIndex = navigationController.viewControllers
            .firstIndex(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }

        navigationController.viewControllers.remove(at: offlineVCIndex)
    }
}

private extension RootCoordinator {
    var mainViewController: MainViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: MainViewController.storyboardIdentifier
        ) { coder in
            MainViewController(
                viewModel: MainViewControllerViewModel(
                    geocodeLocation: GeocodedLocation(
                        geocoder: CLGeocoder()
                    ),
                    notationSettings: NotationSettingsStorage(),
                    metricSystemNotification: MetricSystemNotificationAdapter(
                        notificationCenter: .default
                    ),
                    currentLocationRecord: CurrentLocationRecord(
                        databaseManager: RealmManager()
                    ),
                    databaseManager: RealmManager(),
                    locationManager: LocationManager(),
                    analyticsService: FirebaseAnalyticsService(),
                    networkMonitor: NetworkMonitor()
                ),
                coordinator: self,
                coder: coder
            )
        }

        return viewController
    }

    var themeViewController: ThemeViewController {
        ThemeViewController(
            viewModel: ThemeViewModel(
                notification: NotificationCenterThemeAdapter(
                    notificationCenter: .default
                ),
                analytics: FirebaseAnalyticsThemeAdapter(
                    service: FirebaseAnalyticsService()
                )
            ),
            textColor: .accent,
            darkScheme: .purple,
            lightScheme: .customPrimary
        )
    }

    var aboutViewController: AboutViewController {
        AboutViewController(
            viewModel: AboutViewModel(
                appInfo: ApplicationInfoAdapter(bundle: .main, currentDevice: .current),
                buildConfiguration: FileBuildConfigurationAdapter(bundle: .main),
                networkResourceFactory: NetworkResourceFactory(),
                analytics: FirebaseAnalyticsAboutAdapter(service: FirebaseAnalyticsService()),
                toolbarInteractive: ThemeTipToolbarAdapter(),
                licenseRepository: HtmlPackageLicenseRepository()
            )
        )
    }
}