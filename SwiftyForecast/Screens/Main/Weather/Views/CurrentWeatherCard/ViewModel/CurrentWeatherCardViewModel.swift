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
    @Published private var model: CurrentWeatherModel?
    @Published private var locationModel: LocationModel?

    private var cancellables = Set<AnyCancellable>()
    private let service: WeatherServiceProtocol
    private let measurementSystemNotification: MeasurementSystemNotification
    private let temperatureRenderer: TemperatureRenderer
    private let speedRenderer: SpeedRenderer

    init(
        service: WeatherServiceProtocol = WeatherService(decoder: JSONSnakeCaseDecoded()),
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer(),
        speedRenderer: SpeedRenderer = SpeedRenderer(),
        measurementSystemNotification: MeasurementSystemNotification = MeasurementSystemNotification()
    ) {
        self.service = service
        self.temperatureRenderer = temperatureRenderer
        self.speedRenderer = speedRenderer
        self.measurementSystemNotification = measurementSystemNotification

        subscribeToPublisher()
        registerMeasurementSystemObserver()
    }

    func setLocationModel(_ locationModel: LocationModel) {
        self.locationModel = locationModel
    }

    private func subscribeToPublisher() {
        $locationModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] locationModel in
                loadData(at: locationModel)
            }
            .store(in: &cancellables)

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

                checkCondition(model.condition)
            }
            .store(in: &cancellables)
    }

    private func checkCondition(_ condition: ConditionModel) {
        switch condition.id {
        case 200...232:
            debugPrint(condition.name)
        case 300...321:
            debugPrint(condition.name)
        case 500...531:
            debugPrint(condition.name)
        case 600...622:
            debugPrint(condition.name)
        case 701...781:
            debugPrint(condition.name)
        case 800...804:
            debugPrint(condition.name)
        default:
            debugPrint(condition.name)
        }
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
        guard locationModel != nil else { return }
        do {
            self.locationModel = try RealmManager.shared.readAllSorted().first(where: { $0.name == locationName })
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func loadData(at locationModel: LocationModel) {
        guard !isLoading else { return }
        isLoading = true

        locationName = locationModel.name
        let latitude = locationModel.latitude
        let longitude = locationModel.longitude

        Task(priority: .userInitiated) {
            do {
                let currentResponse = try await service.fetchCurrent(latitude: latitude, longitude: longitude)
                let dataModel = ResponseParser().parse(current: currentResponse)
                let largeIcon = try await service.fetchLargeIcon(symbol: dataModel.condition.iconCode)
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
