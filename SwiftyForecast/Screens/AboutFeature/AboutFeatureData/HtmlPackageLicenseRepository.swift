//
//  HtmlPackageLicenseRepository.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct HtmlPackageLicenseRepository: PackageLicenseRepository {
    private let fileExtension = "html"

    init() {
    }

    func contentURL(for fileName: String) -> URL {
        guard let htmlURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError(CocoaError(.fileNoSuchFile).localizedDescription)
        }
        return htmlURL
    }
}
