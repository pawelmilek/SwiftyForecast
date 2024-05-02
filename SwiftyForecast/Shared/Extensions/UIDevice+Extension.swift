//
//  UIDevice+Extension.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

extension UIDevice {
    struct DeviceModel: Decodable {
        let identifier: String
        let model: String

        static var all: [DeviceModel] {
            do {
                let jsonData = try JSONFileLoader.loadFile(with: "device_types")
                let deviceParser = JSONParser<[DeviceModel]>(decoder: JSONDecoder())
                let models = deviceParser.parse(jsonData)
                return models
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

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
        return DeviceModel.all.first { $0.identifier == identifier }?.model ?? identifier
    }
}
