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
import ThemeFeatureData
import ThemeFeatureDomain
import AboutFeatureUI
import AboutFeatureData
import AboutFeatureDomain

final class RootCoordinator: Coordinator {
    private lazy var themeRepository: ThemeRepository = {
        ThemeRepository(
            dataSource: UserDefaultsThemeDataSource(
                storage: .standard,
                decoder: JSONDecoder(),
                encoder: JSONEncoder()
            )
        )
    }()

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
        ) { [self] coder in
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
                    networkMonitor: NetworkMonitor(),
                    themeRepository: themeRepository
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
                repository: themeRepository,
                notification: NotificationCenterThemeStateAdapter(
                    notificationCenter: .default
                ),
                analytics: FirebaseAnalyticsThemeAdapter(
                    service: FirebaseAnalyticsService()
                )
            ),
            textColor: .accent,
            scheme: (dark: .purple, light: .customPrimary)
        )
    }

    var aboutViewController: AboutViewController {
        AboutViewController(
            viewModel: AboutViewModel(
                appInfo: BundledApplicationInfo(
                    bundle: .main,
                    currentDevice: .current
                ),
                analytics: FirebaseAnalyticsAboutAdapter(
                    service: FirebaseAnalyticsService()
                ),
                toolbarInteractive: ThemeTipToolbarAdapter(),
                appService: NetworkAppService(
                    repository: NetworkAppRepository(
                        dataSource: LocalAppDataSource(
                            localFileResource: LocalFileResource(
                                name: "app_resources",
                                fileExtension: "json",
                                bundle: .main
                            )
                        ),
                        decoder: JSONDecoder()
                    )
                ),
                deviceService: UserDeviceService(
                    repository: ReleasedDevicesRepository(
                        dataSource: LocalDevicesDataSource(),
                        decoder: JSONDecoder()
                    )
                ),
                licenseService: PackagesLicenseService(
                    repository: PackagesLicenseRepository(
                        dataSource: LocalLicenseDataSource(
                            licenseFile: LocalFileResource(
                                name: "packages_license",
                                fileExtension: "html",
                                bundle: .main
                            )
                        )
                    )
                )
            ),
            tintColor: .customPrimary,
            accentColor: .accent
        )
    }
}
