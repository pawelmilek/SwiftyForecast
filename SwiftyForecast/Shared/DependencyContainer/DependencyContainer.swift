//
//  DependencyContainer.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/13/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
//import UIKit

protocol ViewControllerFactory {
    func makeMainViewController() -> MainViewController
}

protocol LocationPlaceFactory {
    func makeLocationPlace() -> LocationPlaceable
}

final class DependencyContainer {

}
