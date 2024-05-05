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
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        let devices = loadDeviceTypes(decoder: JSONDecoder())
        return devices.first { $0.identifier == identifier }?.model ?? identifier
    }

    private func loadDeviceTypes(decoder: JSONDecoder) -> [DeviceModel] {
        do {
            let jsonData = try JSONFileLoader.loadFile(with: "device_types")
            let result = try decoder.decode([DeviceModel].self, from: jsonData)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
