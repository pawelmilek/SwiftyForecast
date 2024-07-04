//
//  UIDevice+Extension.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

extension UIDevice {
    var modelName: String {
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var system = utsname()
        uname(&system)
        let machineMirror = Mirror(reflecting: system.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif

        let devices = ReleasedDevices(
            resourceFile: ResourceFile(
                name: "device_types",
                fileExtension: "json",
                bundle: .main
            ),
            decoder: JSONDecoder()
        )
        return devices.device(with: identifier).model
    }
}
