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
    @Published private(set) var time = ""
    @Published private(set) var name = ""

    private let location: LocationModel
    private let client: WeatherClient
    private let parser: ResponseParser
    private let measurementSystemNotification: MeasurementSystemNotification
    private let temperatureRenderer: TemperatureRenderer
    private var cancellables = Set<AnyCancellable>()
    private let emitTimerPublisherInSeconds = TimeInterval(60)

    init(
        location: LocationModel,
        client: WeatherClient,
        parser: ResponseParser,
        temperatureRenderer: TemperatureRenderer,
        measurementSystemNotification: MeasurementSystemNotification
    ) {
        self.location = location
        self.client = client
        self.parser = parser
        self.temperatureRenderer = temperatureRenderer
        self.measurementSystemNotification = measurementSystemNotification
        self.time = timeOnly(location.secondsFromGMT, from: .now)
        self.locationName = location.name
        self.name = location.name + ", " + location.country

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        self.position = .region(region)
        subscribeTimerPublisher()
    }

    func loadData() async {
        isLoading = true
        do {
            let response = try await client.fetchCurrent(
                latitude: location.latitude,
                longitude: location.longitude
            )
            let model = parser.parse(current: response)
            setTemperature(value: model.temperature)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }

    private func setTemperature(value: TemperatureValue) {
        let rendered = temperatureRenderer.render(value)
        temperature = rendered.currentFormatted
    }

    private func subscribeTimerPublisher() {
        Timer.publish(every: emitTimerPublisherInSeconds, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] date in
                guard let self else { return "" }
                return timeOnly(location.secondsFromGMT, from: date)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.time = time
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

    deinit {
        debugPrint("LocationRowViewModel deinit")
    }
}
