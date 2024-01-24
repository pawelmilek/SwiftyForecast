//
//  PathFinder.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

final class PathFinder {
    static func documentDirectory() throws -> URL {
        guard let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw CocoaError.error(.fileReadUnsupportedScheme)
        }
        return directory
    }
}
