//
//  Coordinator.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
    func openAbout()
    func openAppearanceSwitch()
    func openLocations()
    func dismiss()
    func presentOfflineView()
    func dismissOfflineView()
    func presentLocationAnimation(isLoading: Bool)
}
