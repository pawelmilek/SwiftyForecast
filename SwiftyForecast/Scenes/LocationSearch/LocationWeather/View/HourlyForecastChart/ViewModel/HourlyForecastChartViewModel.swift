//
//  HourlyForecastChartViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/27/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

@MainActor
final class HourlyForecastChartViewModel: ObservableObject {
    static let numberOfThreeHoursForecastItems = 8
    static let chartHeight: CGFloat = 280
    static let dataPointWidth: CGFloat = 65

    @Published var dataSource: [HourlyForecastChartDataSource] = []
    @Published var chartYScaleRange: ClosedRange<Int> = 0...0
    var numberOfHours: Int { dataSource.count }

    private let models: [HourlyForecastModel]
    private let notationController: NotationController
    init(
        models: [HourlyForecastModel],
        notationController: NotationController = NotationController()
    ) {
        self.models = Array(models.prefix(upTo: Self.numberOfThreeHoursForecastItems))
        self.notationController = notationController
        createChartDataSource()
        calculateChartYScaleRange()
    }

    private func createChartDataSource() {
        guard !models.isEmpty else { return }
        self.dataSource = models.compactMap { .init(model: $0) }
    }

    private func calculateChartYScaleRange() {
        let minValue = dataSource.min { leftHand, rightHand in
            return leftHand.temperatureValue < rightHand.temperatureValue
        }?.temperatureValue ?? 0

        let maxValue = dataSource.max { leftHand, rightHand in
            return leftHand.temperatureValue < rightHand.temperatureValue
        }?.temperatureValue ?? 0

        let absoluteValue: Double = {
            let value = maxValue == 0 ? 10 : maxValue
            return Double(abs(value))
        }()
        let percentageOfMaxTemp = ceil(absoluteValue * 0.9)
        let lower = Double(minValue) - percentageOfMaxTemp
        let upper = Double(maxValue) + percentageOfMaxTemp
        chartYScaleRange = Int(lower)...Int(upper)
    }
}
