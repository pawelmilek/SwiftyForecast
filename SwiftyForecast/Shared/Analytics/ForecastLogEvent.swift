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
        static let composeDragDrop = "compose_dropped"
        static let composeSave = "compose_saved"
        static let composePlay = "compose_played"
        static let composeRemove = "compose_removed"
        static let sort = "list_sorted"
        static let favorites = "favorites_toggled"
        static let play = "sound_played"
        static let like = "sound_liked"
        static let share = "sound_shared"
        static let search = "search"
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

    func logComposeDragDropEvent(name: String) {
        service.log(
            event: LogEventType.composeDragDrop,
            parameters: [
                "sound_title": name
            ]
        )
    }

    func logComposeRemoveEvent(content: String) {
        service.log(
            event: LogEventType.composeRemove,
            parameters: [
                "compose_content": content
            ]
        )
    }

    func logComposePlayEvent(content: String) {
        service.log(
            event: LogEventType.composePlay,
            parameters: [
                "compose_content": content
            ]
        )
    }

    func logComposeSaveEvent(name: String, content: String) {
        service.log(
            event: LogEventType.composeSave,
            parameters: [
                "compose_title": name,
                "compose_content": content
            ]
        )
    }

    func logSortEvent(name: String) {
        service.log(
            event: LogEventType.sort,
            parameters: [
                "sort_name": name
            ]
        )
    }

    func logShowFavoritesEvent(value: Bool) {
        service.log(
            event: LogEventType.favorites,
            parameters: [
                "show_favorites": value
            ]
        )
    }

    func logPlayEvent(name: String, playbackCount: Int) {
        service.log(
            event: LogEventType.play,
            parameters: [
                "sound_title": name,
                "playback_count": playbackCount
            ]
        )
    }

    func logLikeEvent(name: String, value: Bool) {
        service.log(
            event: LogEventType.like,
            parameters: [
                "sound_title": name,
                "like_value": value
            ]
        )
    }

    func logShareEvent(name: String, playCount: Int) {
        service.log(
            event: LogEventType.share,
            parameters: [
                "sound_title": name,
                "playback_count": playCount
            ]
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
