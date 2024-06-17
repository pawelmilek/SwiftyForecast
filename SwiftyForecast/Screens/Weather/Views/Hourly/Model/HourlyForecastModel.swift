//
//  HourlyForecastModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyForecastModel {
    let date: Date
    let temperature: Double?
    let icon: String
}

extension HourlyForecastModel {
    static let initialData: [HourlyForecastModel] = {
        [
            .init(
                date: .now,
                temperature: nil,
                icon: WeatherCondition.allCases.randomElement()!.icon
            ),
            .init(
                date: Calendar.current.date(byAdding: .hour, value: 3, to: .now)!,
                temperature: nil,
                icon: WeatherCondition.allCases.randomElement()!.icon
            ),
            .init(
                date: Calendar.current.date(byAdding: .hour, value: 6, to: .now)!,
                temperature: nil,
                icon: WeatherCondition.allCases.randomElement()!.icon
            ),
            .init(
                date: Calendar.current.date(byAdding: .hour, value: 9, to: .now)!,
                temperature: nil,
                icon: WeatherCondition.allCases.randomElement()!.icon
            ),
            .init(
                date: Calendar.current.date(byAdding: .hour, value: 12, to: .now)!,
                temperature: nil,
                icon: WeatherCondition.allCases.randomElement()!.icon
            )
        ]
    }()
}
