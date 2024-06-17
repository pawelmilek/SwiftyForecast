//
//  HourlyForecastFlowLayout.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class HourlyForecastFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    private let cellsInRow: CGFloat
    private let sizeForItem: CGSize

    init(cellsInRow: CGFloat, sizeForItem: CGSize) {
        self.cellsInRow = cellsInRow
        self.sizeForItem = sizeForItem
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return sizeForItem
        }

        let sectionInsetLeftAndRightSum = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let numberOfHorizontalSpacing = cellsInRow - 1
        let minimumLineSpacing = flowLayout.minimumLineSpacing

        let collectionViewWidth = collectionView.frame.size.width
        let totalAvailableSpace = sectionInsetLeftAndRightSum + (minimumLineSpacing * numberOfHorizontalSpacing)

        let width = (collectionViewWidth - totalAvailableSpace) / cellsInRow
        return CGSize(width: width, height: sizeForItem.height)
    }
}
