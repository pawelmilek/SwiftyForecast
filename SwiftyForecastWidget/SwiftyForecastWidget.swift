//
//  SwiftyForecastWidgetEntryView.swift
//  SwiftyForecast Widget
//
//  Created by Pawel Milek on 12/6/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct SwiftyForecastWidget: Widget {
    private enum Constant {
        static let kind = "com.pawelmilek.Swifty-Forecast.widget"
        static let supportedFamilies: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ]
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Constant.kind,
            provider: WeatherTimelineProvider(
                locationManager: WidgetLocationManager(),
                repositoryFactory: WeatherEntryRepositoryFactory(
                    client: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
                    locationPlace: GeocodedLocation(geocoder: CLGeocoder()),
                    parser: ResponseParser(),
                    temperatureFormatterFactory: TemperatureFormatterFactory(
                        notationStorage: NotationSystemStorage()
                    )
                )
            )
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Weather")
        .description("Glance the current conditions and forecast for a location.")
        .supportedFamilies(Constant.supportedFamilies)
    }
}

#Preview(as: .systemSmall) {
    SwiftyForecastWidget()
} timeline: {
    WeatherEntry.sampleTimeline.first!
    WeatherEntry.sampleTimeline.last!
}

#Preview(as: .systemMedium) {
    SwiftyForecastWidget()
} timeline: {
    WeatherEntry.sampleTimeline.first!
    WeatherEntry.sampleTimeline.last!
}
