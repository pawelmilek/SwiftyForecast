//
//  ForecastLogEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

final class ForecastLogEvent: ObservableObject {
    enum LogEventType {
        static let aboutRow = "about_row_tapped"
        static let search = "location_searched"
        static let location = "location_selected"
        static let screen = "screen_view"
    }

    private let service: LogEventService

    init(service: LogEventService) {
        self.service = service
    }

    func logAboutRowEvent(title: String) {
        service.log(
            event: LogEventType.aboutRow,
            parameters: ["row_title": title]
        )
    }

    func logSearchEvent(searchTerm: String) {
        service.log(
            event: LogEventType.search,
            parameters: [
                "search_term": searchTerm
            ]
        )
    }

    func logScreenEvent(name: String, className: String) {
        service.log(
            event: LogEventType.screen,
            parameters: [
                "screen_name": name,
                "screen_class": className
            ]
        )
    }
}
