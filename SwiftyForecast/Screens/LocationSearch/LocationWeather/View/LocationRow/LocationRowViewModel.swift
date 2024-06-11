//
//  LocationRowViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 3/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import MapKit
import Combine
import SwiftUI

@MainActor
final class LocationRowViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    @Published private(set) var locationName = ""
    @Published private(set) var temperature = ""
    @Published private(set) var locationCurrentTimeFormatted = ""
    @Published private(set) var name = ""
    @Published private(set) var temperatureValue: TemperatureValue?
    @Published private(set) var location: LocationModel?

    private var locationSecondsFromGMT = 0
    private let service: WeatherService
    private let measurementSystemNotification: MeasurementSystemNotification
    private let temperatureRenderer: TemperatureRenderer
    private var cancellables = Set<AnyCancellable>()
    private let emitTimerPublisherInSeconds = TimeInterval(60)

    init(
        location: LocationModel,
        service: WeatherService,
        temperatureRenderer: TemperatureRenderer,
        measurementSystemNotification: MeasurementSystemNotification) {
            self.service = service
            self.temperatureRenderer = temperatureRenderer
            self.measurementSystemNotification = measurementSystemNotification

            subscribeToPublishers()
            registerMeasurementSystemObserver()
            self.location = location
        }

    func loadData(at locationModel: LocationModel) {
        guard !isLoading else { return }
        isLoading = true

        locationName = locationModel.name

        Task(priority: .userInitiated) {
            do {
                let latitude = locationModel.latitude
                let longitude = locationModel.longitude

                let currentResponse = try await service.fetchCurrent(
                    latitude: latitude,
                    longitude: longitude
                )
                let model = ResponseParser().parse(current: currentResponse)
                temperatureValue = model.temperature
                isLoading = false
            } catch {
                self.error = error
                temperatureValue = nil
                isLoading = false
            }
        }
    }

    private func subscribeToPublishers() {
        $location
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self else { return }
                locationSecondsFromGMT = location.secondsFromGMT
                locationCurrentTimeFormatted = timeOnly(location.secondsFromGMT, from: .now)
                name = location.name + ", " + location.country

                let annotation = MKPointAnnotation()
                annotation.subtitle = "\(location.name) \(location.state)"
                annotation.coordinate = CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )

                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                position = .region(region)
                loadData(at: location)
            }
            .store(in: &cancellables)

        $temperatureValue
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] temperatureValue in
                self?.setTemperatureAccordingToUnitNotation(value: temperatureValue)
            }
            .store(in: &cancellables)

        Timer.publish(every: emitTimerPublisherInSeconds, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] date in
                guard let self else { return "" }
                return timeOnly(locationSecondsFromGMT, from: date)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationCurrentTimeFormatted in
                guard let self else { return }
                self.locationCurrentTimeFormatted = locationCurrentTimeFormatted
            }
            .store(in: &cancellables)
    }

    private func timeOnly(_ secondsFromGMT: Int, from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        let time = dateFormatter.string(from: date)
        return time
    }

    private func registerMeasurementSystemObserver() {
        measurementSystemNotification.addObserver(
            self,
            selector: #selector(measurementSystemChanged)
        )
    }

    @objc
    private func measurementSystemChanged() {
        guard let temperatureValue else { return }
        setTemperatureAccordingToUnitNotation(value: temperatureValue)
    }

    private func setTemperatureAccordingToUnitNotation(value: TemperatureValue) {
        let rendered = temperatureRenderer.render(value)
        temperature = rendered.currentFormatted
    }

    deinit {
        debugPrint("LocationRowViewModel deinit")
    }
}
