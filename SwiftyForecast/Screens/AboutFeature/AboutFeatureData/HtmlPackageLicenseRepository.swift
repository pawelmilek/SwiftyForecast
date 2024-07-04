//
//  HtmlPackageLicenseRepository.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct HtmlPackageLicenseRepository: PackageLicenseRepository {
    private let resourceFile: ResourceFile
    private let fileExtension = "html"

    init(resourceFile: ResourceFile) {
        self.resourceFile = resourceFile
    }

    func contentURL() -> URL {
        do {
            return try resourceFile.url()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
