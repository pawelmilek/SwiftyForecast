//
//  LicenseReader.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

class LicenseReader: ObservableObject {
    @Published private(set) var fileURL: URL?

    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    func readFileURL() throws {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "html") else {
            throw FileLoaderError.fileNotFound(name: fileName)
        }

        fileURL = url
    }
}
