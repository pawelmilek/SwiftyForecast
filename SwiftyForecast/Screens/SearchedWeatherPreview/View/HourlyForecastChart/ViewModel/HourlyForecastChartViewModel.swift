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
    static let chartHeight: CGFloat = 280
    static let dataPointWidth: CGFloat = 65

    @Published var dataSource = [HourlyForecastChartDataSource]()
    @Published var chartYScaleRange: ClosedRange<Int> = 0...0
    var numberOfHours: Int { dataSource.count }

    init(models: [HourlyForecastModel]) {
        dataSource = models.compactMap {
            .init(model: $0, temperatureRenderer: TemperatureRenderer())
        }
        calculateChartYScaleRange()
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
