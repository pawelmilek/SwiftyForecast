//
//  ReleasedDevices.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ReleasedDevices {
    private let decoder: JSONDecoder
    private let resourceFile: ResourceFile

    init() {
        self.init(
            resourceFile: ResourceFile(name: "device_types", fileExtension: "json"),
            decoder: JSONDecoder()
        )
    }

    init(resourceFile: ResourceFile, decoder: JSONDecoder) {
        self.resourceFile = resourceFile
        self.decoder = decoder
    }

    func device(with identifier: String) -> Device {
        devices()
            .first(where: { $0.identifier == identifier }) ?? Device(identifier: identifier, model: identifier)
    }

    func devices() -> [Device] {
        do {
            let jsonData = try resourceFile.data()
            let models = try decoder.decode([Device].self, from: jsonData)
            return models
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
