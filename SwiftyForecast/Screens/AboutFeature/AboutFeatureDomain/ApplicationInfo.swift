//
//  ApplicationInfo.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol ApplicationInfo {
    var name: String { get }
    var version: String { get }
    var device: String { get }
    var system: String { get }
    var compatibility: String { get }
}
