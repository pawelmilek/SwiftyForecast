//
//  PathFinder.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct PathFinder {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func documentDirectory() throws -> URL {
        guard let directory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw CocoaError.error(.fileReadUnsupportedScheme)
        }
        return directory
    }
}
