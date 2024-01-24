//
//  ForecastWeatherModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

struct ForecastWeatherModel {
    let hourly: [HourlyForecastModel]
    let daily: [DailyForecastModel]
}
