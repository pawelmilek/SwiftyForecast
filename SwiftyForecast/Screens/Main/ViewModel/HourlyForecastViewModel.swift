//
//  HourlyForecastViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyForecastData {
    let time: String
    let iconURL: URL?
    let temperature: String
}

final class HourlyForecastViewModel {
    var numberOfItems: Int { hourlyViewModels.count }

    private let hourlyViewModels: [HourlyViewCell.ViewModel]
    private let models: [HourlyForecastModel]

    init(models: [HourlyForecastModel]) {
        self.models = models
        self.hourlyViewModels = models.map { .init(model: $0) }
    }

    func hourlyItem(at indexPath: IndexPath) -> HourlyForecastData? {
        guard let hourlyViewModel = hourlyViewModels[safe: indexPath.row] else { return nil }

        return HourlyForecastData(
            time: hourlyViewModel.time,
            iconURL: hourlyViewModel.iconURL,
            temperature: hourlyViewModel.temperature
        )
    }

}
