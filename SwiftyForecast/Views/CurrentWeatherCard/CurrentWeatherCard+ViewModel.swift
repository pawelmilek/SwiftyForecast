//
//  CurrentWeatherCard+ViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension CurrentWeatherCard {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var error: Error?
        @Published private(set) var isLoading = false
        @Published private(set) var locationName = ""
        @Published private(set) var icon: Image?
        @Published private(set) var description = "-"
        @Published private(set) var daytimeDescription = "-"
        @Published private(set) var temperature = "--"
        @Published private(set) var temperatureMaxMin = "--"
        @Published private(set) var sunrise = Twilight.sunrise(time: "")
        @Published private(set) var sunset = Twilight.sunset(time: "")
        @Published private(set) var windSpeed = WindSpeed(value: "")
        @Published private(set) var humidity = Humidity(value: "")
        @Published private var model: CurrentWeatherModel?
        @Published private var locationModel: LocationModel?

        private var cancellables = Set<AnyCancellable>()
        private let service: WeatherServiceProtocol
        private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
        private let speedFormatterFactory: SpeedFormatterFactoryProtocol
        private let notationController: NotationController
        private let measurementSystemNotification: MeasurementSystemNotification

        init(service: WeatherServiceProtocol = WeatherService(),
             temperatureFormatterFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory(),
             speedFormatterFactory: SpeedFormatterFactoryProtocol = SpeedFormatterFactory(),
             notationController: NotationController = NotationController(),
             measurementSystemNotification: MeasurementSystemNotification = MeasurementSystemNotification()) {
            self.service = service
            self.temperatureFormatterFactory = temperatureFormatterFactory
            self.speedFormatterFactory = speedFormatterFactory
            self.notationController = notationController
            self.measurementSystemNotification = measurementSystemNotification
            subscribeToPublisher()
            registerMeasurementSystemObserver()
        }

        private func subscribeToPublisher() {
            $model
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [self] model in
                    setTemperatureAccordingToUnitNotation()
                    setWindSpeedAccordingToMeasurementSystem()
                    description = model.description
                    daytimeDescription = Daytime(rawValue: model.dayNightState.description)?.rawValue ?? ""
                    humidity.value = "\(model.humidity)\("%")"
                    sunrise = .sunrise(time: model.sunrise.shortTime)
                    sunset = .sunset(time: model.sunset.shortTime)
                }
                .store(in: &cancellables)
        }

        private func setTemperatureAccordingToUnitNotation() {
            guard let model else { return }

            let temperatureFormatter = temperatureFormatterFactory.make(
                by: notationController.temperatureNotation,
                valueInKelvin: TemperatureValue(
                    current: model.temperature,
                    max: model.maxTemperature,
                    min: model.minTemperature
                )
            )
            temperature = temperatureFormatter.currentFormatted
            temperatureMaxMin = "⏶ \(temperatureFormatter.maxFormatted)  ⏷ \(temperatureFormatter.minFormatted)"
        }

        private func setWindSpeedAccordingToMeasurementSystem() {
            guard let model else { return }

            let speedFormatter = speedFormatterFactory.make(
                by: notationController.measurementSystem,
                valueInMetersPerSec: model.windSpeed
            )
            windSpeed.value = speedFormatter.current
        }

        private func registerMeasurementSystemObserver() {
            measurementSystemNotification.addObserver(
                self,
                selector: #selector(measurementSystemChanged)
            )
        }

        @objc
        private func measurementSystemChanged() {
            setTemperatureAccordingToUnitNotation()
            setWindSpeedAccordingToMeasurementSystem()
        }

        func loadData() {
            guard let locationModel else { return }
            loadWeather(at: locationModel)
        }

        func loadWeather(at location: LocationModel) {
            guard !isLoading else { return }
            isLoading = true
            locationName = location.name
            locationModel = location

            Task(priority: .userInitiated) {
                do {
                    let currentResponse = try await service.fetchCurrent(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                    let dataModel = ResponseParser.parse(current: currentResponse)
                    let largeIcon = try await service.fetchLargeIcon(symbol: dataModel.icon)
                    icon = Image(uiImage: largeIcon)
                    model = dataModel
                    isLoading = false
                } catch {
                    icon = nil
                    model = nil
                    self.error = error
                    isLoading = false
                }
            }
        }
    }
}
