//
//  BundledApplicationInfo.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import AboutFeatureUI

@MainActor
struct BundledApplicationInfo: ApplicationInfo {
    let name: String
    let version: String
    let deviceId: String
    let system: String
    let compatibility: String

    init(bundle: Bundle, currentDevice: UIDevice) {
        self.name = bundle.applicationName
        self.version = "\(bundle.versionNumber) (\(bundle.buildNumber))"
        self.deviceId = currentDevice.identifier
        self.system = "\(currentDevice.systemName): \(currentDevice.systemVersion)"
        self.compatibility = "iOS \(bundle.minimumOSVersion)"
    }
}
