//
//  WeatherCardViewViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class WeatherCardViewViewModel: ObservableObject {
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    @Published private(set) var locationName = "--"
    @Published private(set) var icon: Image?
    @Published private(set) var description = "--"
    @Published private(set) var daytimeDescription = "--"
    @Published private(set) var temperature = "--"
    @Published private(set) var temperatureMaxMin = "--"
    @Published private(set) var sunrise = Twilight.sunrise(time: "--")
    @Published private(set) var sunset = Twilight.sunset(time: "--")
    @Published private(set) var windSpeed = WindSpeed(value: "--")
    @Published private(set) var humidity = Humidity(value: "--")
    @Published private(set) var condition: WeatherCondition = .none
    @Published private var weatherModel: WeatherModel?

    private var cancellables = Set<AnyCancellable>()
    private let latitude: Double
    private let longitude: Double
    private let service: WeatherServiceProtocol
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    private let speedFormatterFactory: SpeedFormatterFactoryProtocol
    private let metricSystemNotification: MetricSystemNotification

    init(
        latitude: Double,
        longitude: Double,
        locationName: String,
        service: WeatherServiceProtocol,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol,
        speedFormatterFactory: SpeedFormatterFactoryProtocol,
        metricSystemNotification: MetricSystemNotification
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.service = service
        self.temperatureFormatterFactory = temperatureFormatterFactory
        self.speedFormatterFactory = speedFormatterFactory
        self.metricSystemNotification = metricSystemNotification
        subscribePublishers()
    }

    private func subscribePublishers() {
        $weatherModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] weatherModel in
                setTemperatureAccordingToUnitNotation()
                setWindSpeedAccordingToMeasurementSystem()
                description = weatherModel.condition.description
                daytimeDescription = weatherModel.condition.state.description
                humidity.value = "\(weatherModel.humidity)\("%")"
                sunrise = .sunrise(time: weatherModel.sunrise.formatted(date: .omitted, time: .shortened))
                sunset = .sunset(time: weatherModel.sunset.formatted(date: .omitted, time: .shortened))
                condition = WeatherCondition(code: weatherModel.condition.id)
            }
            .store(in: &cancellables)

        metricSystemNotification.publisher()
            .sink { [weak self] _ in
                self?.metricSystemChanged()
            }
            .store(in: &cancellables)
    }

    private func metricSystemChanged() {
        setTemperatureAccordingToUnitNotation()
        setWindSpeedAccordingToMeasurementSystem()
    }

    private func setTemperatureAccordingToUnitNotation() {
        guard let temp = weatherModel?.temperature else { return }
        let formatter = temperatureFormatterFactory.make(by: temp)
        temperature = formatter.current()
        temperatureMaxMin = formatter.maxMin()
    }

    private func setWindSpeedAccordingToMeasurementSystem() {
        guard let wind = weatherModel?.windSpeed else { return }
        let formatter = speedFormatterFactory.make(value: wind)
        windSpeed.value = formatter.current()
    }

    func loadData() async {
        defer { isLoading = false }
        isLoading = true

        do {
            weatherModel = try await service.weather(
                latitude: latitude,
                longitude: longitude
            )

            let largeIconData = try await service.largeIcon(
                symbol: weatherModel?.condition.iconCode ?? ""
            )

            if let image = UIImage(data: largeIconData) {
                icon = Image(uiImage: image)
            }
        } catch {
            icon = nil
            weatherModel = nil
            self.error = error
            isLoading = false
        }
    }
}
