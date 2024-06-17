//
//  DailyForecastModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct DailyForecastModel {
    let date: Date
    let icon: String
    let temperature: Double?
}

extension DailyForecastModel {
    static let initialData: [DailyForecastModel] = {
        [
            .init(
                date: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                icon: WeatherCondition.allCases.randomElement()!.icon,
                temperature: nil
            ),
            .init(
                date: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
                icon: WeatherCondition.allCases.randomElement()!.icon,
                temperature: nil
            ),
            .init(
                date: Calendar.current.date(byAdding: .day, value: 3, to: .now)!,
                icon: WeatherCondition.allCases.randomElement()!.icon,
                temperature: nil
            ),
            .init(
                date: Calendar.current.date(byAdding: .day, value: 4, to: .now)!,
                icon: WeatherCondition.allCases.randomElement()!.icon,
                temperature: nil
            ),
            .init(
                date: Calendar.current.date(byAdding: .day, value: 5, to: .now)!,
                icon: WeatherCondition.allCases.randomElement()!.icon,
                temperature: nil
            )
        ]
    }()
}
