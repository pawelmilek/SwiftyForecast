//
//  PackageLicense.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

class PackageLicense: ObservableObject {
    @Published private(set) var url: URL?
    private let resourceFile: ResourceFile

    init(resourceFile: ResourceFile) {
        self.resourceFile = resourceFile
    }

    func loadURL() throws {
        url = try resourceFile.fileURL()
    }
}
