//
//  EntryRepositoryFactory.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/20/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol EntryRepositoryFactory {
    func make(_ isSystemMediumFamily: Bool) -> WeatherEntryRepository
}
