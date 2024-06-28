//
//  RootCoordinator.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices

final class RootCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: MainViewController.storyboardIdentifier
        ) { coder in
            MainViewController(
                viewModel: CompositionRoot.mainViewModel,
                coordinator: self,
                coder: coder
            )
        }

        navigationController.pushViewController(viewController, animated: false)
        debugPrint(CompositionRoot.databaseManager.description)
    }

    func openAbout() {
        navigationController.present(
            AboutViewController(
                viewModel: CompositionRoot.aboutViewModel,
                coordinator: self
            ),
            animated: true
        )
    }

    func openAppearanceSwitch() {
        navigationController.present(
            ThemeViewController(
                viewModel: CompositionRoot.themeViewModel,
                coordinator: self
            ),
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

    func presentLocationAnimation(isLoading: Bool) {
        if isLoading {
            guard !navigationController.viewControllers
                .contains(where: { $0.view.tag == LottieAnimationViewController.identifier }) else {
                return
            }
            navigationController.pushViewController(LottieAnimationViewController(), animated: false)

        } else {
            guard let index = navigationController.viewControllers
                .firstIndex(where: { $0.view.tag == LottieAnimationViewController.identifier }) else {
                return
            }
            navigationController.viewControllers.remove(at: index)
        }
    }
}
