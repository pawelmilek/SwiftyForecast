//
//  ApplicationInfoAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

@MainActor
struct ApplicationInfoAdapter: ApplicationInfo {
    let name: String
    let version: String
    let device: String
    let system: String
    let compatibility: String

    init(bundle: Bundle, currentDevice: UIDevice) {
        self.name = bundle.applicationName
        self.version = "\(bundle.versionNumber) (\(bundle.buildNumber))"
        self.device = currentDevice.modelName
        self.system = "\(currentDevice.systemName): \(currentDevice.systemVersion)"
        self.compatibility = "iOS \(bundle.minimumOSVersion)"
    }
}
