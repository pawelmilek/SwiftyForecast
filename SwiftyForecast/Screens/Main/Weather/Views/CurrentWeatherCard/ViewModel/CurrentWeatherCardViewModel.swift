//
//  CurrentWeatherCardViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CurrentWeatherCardViewModel: ObservableObject {
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
    @Published private var model: CurrentWeatherModel?

    private var cancellables = Set<AnyCancellable>()
    private var location: LocationModel
    private let client: WeatherClient
    private let measurementSystemNotification: MeasurementSystemNotification
    private let temperatureRenderer: TemperatureRenderer
    private let speedRenderer: SpeedRenderer

    init(
        location: LocationModel,
        client: WeatherClient,
        temperatureRenderer: TemperatureRenderer,
        speedRenderer: SpeedRenderer,
        measurementSystemNotification: MeasurementSystemNotification
    ) {
        self.location = location
        self.client = client
        self.temperatureRenderer = temperatureRenderer
        self.speedRenderer = speedRenderer
        self.measurementSystemNotification = measurementSystemNotification
        self.condition = .none
        self.locationName = location.name
        subscribeToPublisher()
        registerMeasurementSystemObserver()
    }

    func setLocationModel(_ location: LocationModel) {
        self.location = location
    }

    private func subscribeToPublisher() {
        $model
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] model in
                setTemperatureAccordingToUnitNotation()
                setWindSpeedAccordingToMeasurementSystem()
                description = model.condition.description
                daytimeDescription = model.condition.state.description
                humidity.value = "\(model.humidity)\("%")"
                sunrise = .sunrise(time: model.sunrise.formatted(date: .omitted, time: .shortened))
                sunset = .sunset(time: model.sunset.formatted(date: .omitted, time: .shortened))
                condition = WeatherCondition(code: model.condition.id)
            }
            .store(in: &cancellables)
    }

    private func setTemperatureAccordingToUnitNotation() {
        guard let model else { return }
        let rendered = temperatureRenderer.render(model.temperature)
        temperature = rendered.currentFormatted
        temperatureMaxMin = rendered.maxMinFormatted
    }

    private func setWindSpeedAccordingToMeasurementSystem() {
        guard let model else { return }
        let rendered = speedRenderer.render(model.windSpeed)
        windSpeed.value = rendered
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

    func reloadCurrentLocation() {
        if let location = try? RealmManager.shared.readAllSorted().first(where: { $0.name == locationName }) {
            self.location = location
            self.loadData()
        } else {
            fatalError()
        }
    }

    func loadData() {
        guard !isLoading else { return }
        isLoading = true

        Task(priority: .userInitiated) {
            do {
                let response = try await client.fetchCurrent(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                let dataModel = ResponseParser().parse(current: response)
                let largeIcon = try await client.fetchLargeIcon(
                    symbol: dataModel.condition.iconCode
                )
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
