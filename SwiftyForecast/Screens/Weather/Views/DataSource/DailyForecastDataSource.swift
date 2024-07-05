//
//  DailyForecastDataSource.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class DailyForecastDataSource: NSObject, UITableViewDataSource {
    private var viewModeles: [DailyViewCellViewModel]

    convenience override init() {
        self.init(viewModeles: [])
    }

    init(viewModeles: [DailyViewCellViewModel]) {
        self.viewModeles = viewModeles
    }

    // TODO: Move DailyViewCellViewModel dependency up to Composition Root
    func set(data: [DailyForecastModel]) {
        self.viewModeles = data.map {
            DailyViewCellViewModel(
                model: $0,
                temperatureFormatterFactory: TemperatureFormatterFactory(
                    notationStorage: NotationSettingsStorage()
                )
            )
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModeles.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyViewCell.reuseIdentifier,
            for: indexPath
        ) as? DailyViewCell else { return UITableViewCell() }

        guard !viewModeles.isEmpty else { return cell }
        cell.set(viewModel: viewModeles[indexPath.row])
        return cell
    }
}
