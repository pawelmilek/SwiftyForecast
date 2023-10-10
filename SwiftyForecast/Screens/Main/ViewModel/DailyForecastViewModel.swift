//
//  DailyForecastViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct DailyForecastData {
    let attributedDate: NSAttributedString
    let iconURL: URL?
    let temperature: String
}

final class DailyForecastViewModel {
    var numberOfItems: Int { dailyViewModels.count }

    private let dailyViewModels: [DailyViewCell.ViewModel]
    private let models: [DailyForecastModel]

    init(models: [DailyForecastModel]) {
        self.models = models
        self.dailyViewModels = models.map { DailyViewCell.ViewModel(model: $0) }
    }

    @MainActor
    func dailyItem(at indexPath: IndexPath) -> DailyForecastData? {
        guard let dailyViewModel = dailyViewModels[safe: indexPath.row] else { return nil }

        return DailyForecastData(
            attributedDate: dailyViewModel.attributedDate,
            iconURL: dailyViewModel.iconURL,
            temperature: dailyViewModel.temperature
        )
    }

}
