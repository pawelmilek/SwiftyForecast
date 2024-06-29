//
//  HourlyForcecastDataSource.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class HourlyForcecastDataSource: NSObject, UICollectionViewDataSource {
    private var viewModels: [HourlyViewCellViewModel]

    override convenience init() {
        self.init(viewModels: [])
    }

    init(viewModels: [HourlyViewCellViewModel]) {
        self.viewModels = viewModels
    }

    func set(data: [HourlyForecastModel]) {
        self.viewModels = data.map { CompositionRoot.hourlyViewModel($0) }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyViewCell.reuseIdentifier,
            for: indexPath
        ) as? HourlyViewCell else {
            return HourlyViewCell()
        }

        guard !viewModels.isEmpty else { return cell }
        cell.set(viewModel: viewModels[indexPath.row])
        return cell
    }

}
