//
//  DeviceModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 5/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct DeviceModel: Decodable {
    let identifier: String
    let model: String
}

extension DeviceModel {
    static var all: [DeviceModel] {
        do {
            let json = ResourceFile(name: "device_types", fileExtension: "json")
            let jsonData = try json.data()
            let models = try JSONDecoder().decode([DeviceModel].self, from: jsonData)
            return models
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
