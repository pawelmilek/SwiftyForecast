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
    @Published private(set) var condition: WeatherCondition
    @Published private var weatherModel: WeatherModel?

    private var cancellables = Set<AnyCancellable>()
    private let latitude: Double
    private let longitude: Double
    private let client: WeatherClient
    private let parser: WeatherResponseParser
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    private let speedFormatterFactory: SpeedFormatterFactoryProtocol
    private let measurementSystemNotification: MeasurementSystemNotification

    init(
        latitude: Double,
        longitude: Double,
        locationName: String,
        client: WeatherClient,
        parser: WeatherResponseParser,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol,
        speedFormatterFactory: SpeedFormatterFactoryProtocol,
        measurementSystemNotification: MeasurementSystemNotification
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.client = client
        self.parser = parser
        self.temperatureFormatterFactory = temperatureFormatterFactory
        self.speedFormatterFactory = speedFormatterFactory
        self.measurementSystemNotification = measurementSystemNotification
        self.condition = .none
        subscribeToPublisher()
        registerMeasurementSystemObserver()
    }

    private func subscribeToPublisher() {
        $weatherModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] currentWeatherModel in
                setTemperatureAccordingToUnitNotation()
                setWindSpeedAccordingToMeasurementSystem()
                description = currentWeatherModel.condition.description
                daytimeDescription = currentWeatherModel.condition.state.description
                humidity.value = "\(currentWeatherModel.humidity)\("%")"
                sunrise = .sunrise(time: currentWeatherModel.sunrise.formatted(date: .omitted, time: .shortened))
                sunset = .sunset(time: currentWeatherModel.sunset.formatted(date: .omitted, time: .shortened))
                condition = WeatherCondition(code: currentWeatherModel.condition.id)
            }
            .store(in: &cancellables)
    }

    private func setTemperatureAccordingToUnitNotation() {
        guard let weatherModel else { return }
        let formatter = temperatureFormatterFactory.make(by: weatherModel.temperature)
        temperature = formatter.current()
        temperatureMaxMin = formatter.maxMin()
    }

    private func setWindSpeedAccordingToMeasurementSystem() {
        guard let weatherModel else { return }
        let formatter = speedFormatterFactory.make(value: weatherModel.windSpeed)
        windSpeed.value = formatter.current()
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

    func loadData() async {
        defer { isLoading = false }
        isLoading = true
        do {
            let response = try await client.fetchCurrent(
                latitude: latitude,
                longitude: longitude
            )
            let dataModel = parser.weather(response: response)
            let largeIconData = try await client.fetchLargeIcon(
                symbol: dataModel.condition.iconCode
            )
            if let image = UIImage(data: largeIconData) {
                icon = Image(uiImage: image)
            }
            weatherModel = dataModel
        } catch {
            icon = nil
            weatherModel = nil
            self.error = error
            isLoading = false
        }
    }
}
