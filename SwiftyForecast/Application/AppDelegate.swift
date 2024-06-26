//
//  AppDelegate.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import TipKit
import FirebaseCore
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: RootCoordinator?
    private var cancellables = Set<AnyCancellable>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupFirebase()
        setupCoordinator()
        setupTips()
        setupNavigationBarStyle()
        return true
    }
}

// MARK: - Private - Setups
private extension AppDelegate {

    func setupFirebase() {
        FirebaseApp.configure()
    }

    func setupCoordinator() {
        coordinator = RootCoordinator(navigationController: UINavigationController())
        coordinator?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
    }

    func setupTips() {
//        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }

    func setupNavigationBarStyle() {
        let setTransparentBackground = {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().clipsToBounds = false
        }

        let setTitleTextColor = {
            let textAttributes = [NSAttributedString.Key.foregroundColor: Style.NavigationBar.titleColor]
            UINavigationBar.appearance().titleTextAttributes = textAttributes
        }

        let setBarButtonItemColor = {
            UINavigationBar.appearance().tintColor = Style.NavigationBar.barButtonItemColor
        }

        setTransparentBackground()
        setTitleTextColor()
        setBarButtonItemColor()
    }
}
