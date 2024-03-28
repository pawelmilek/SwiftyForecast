//
//  LocationRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

@MainActor
final class LocationRowViewModel: ObservableObject {
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    @Published private(set) var locationName = ""
    @Published private(set) var temperature = ""
    @Published private(set) var localTime = ""
    @Published private(set) var name = ""
    @Published private(set) var region = MKCoordinateRegion()
    @Published private(set) var temperatureValue: TemperatureValue?
    @Published private(set) var location: LocationModel?

    private let service: WeatherServiceProtocol
    private let measurementSystemNotification: MeasurementSystemNotification
    private let temperatureRenderer: TemperatureRenderer
    private var cancellables = Set<AnyCancellable>()

    init(
        location: LocationModel,
        service: WeatherServiceProtocol,
        temperatureRenderer: TemperatureRenderer,
        measurementSystemNotification: MeasurementSystemNotification) {
            self.service = service
            self.temperatureRenderer = temperatureRenderer
            self.measurementSystemNotification = measurementSystemNotification

            subscribeToPublisher()
            registerMeasurementSystemObserver()
            self.location = location
        }

    func loadData(at locationModel: LocationModel) {
        guard !isLoading else { return }
        isLoading = true

        locationName = locationModel.name
        let latitude = locationModel.latitude
        let longitude = locationModel.longitude

        Task(priority: .userInitiated) {
            do {
                let currentResponse = try await service.fetchCurrent(
                    latitude: latitude,
                    longitude: longitude
                )
                let model = ResponseParser.parse(current: currentResponse)
                temperatureValue = model.temperatureValue
                isLoading = false
            } catch {
                self.error = error
                temperatureValue = nil
                isLoading = false
            }
        }
    }

    private func subscribeToPublisher() {
        $location
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] location in
                localTime = Date.timeOnly(from: location.secondsFromGMT)
                name = location.name + ", " + location.country

                let annotation = MKPointAnnotation()
                annotation.subtitle = "\(location.name) \(location.state)"
                annotation.coordinate = CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )

                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                loadData(at: location)
            }
            .store(in: &cancellables)

        $temperatureValue
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] temperatureValue in
                setTemperatureAccordingToUnitNotation(value: temperatureValue)
            }
            .store(in: &cancellables)
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
}

struct LocationRow: View {
    @State private var position: MapCameraPosition = .automatic
    @ObservedObject var viewModel: LocationRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            headerView
            mapView
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: Style.LocationRow.cornerRadius,
                        style: .continuous
                    )
                    .inset(by: 2.5)
                )
                .shadow(
                    color: Style.LocationRow.shadowColor,
                    radius: Style.LocationRow.shadowRadius,
                    x: Style.LocationRow.shadowOffset.x,
                    y: Style.LocationRow.shadowOffset.y
                )
        }
        .padding(8)
        .frame(minHeight: 145, maxHeight: 145)
        .fixedSize(horizontal: false, vertical: true)
        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .onChange(of: viewModel.region, initial: false) {
            position = .region(viewModel.region)
        }
    }
}

private extension LocationRow {

    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.localTime)
                    .font(Style.LocationRow.timeFont)
                    .foregroundStyle(.customPrimary)
                Text(viewModel.name)
                    .font(Style.LocationRow.nameFont)
                    .foregroundStyle(Style.LocationRow.nameColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.temperature)
                .font(Style.LocationRow.tempFont)
                .foregroundStyle(Style.LocationRow.tempColor)
                .overlay {
                    ProgressView()
                        .tint(.customPrimary)
                        .opacity(viewModel.isLoading ? 1 : 0)
                        .animation(.easeOut, value: viewModel.isLoading)
                }
        }
    }

    var mapView: some View {
        Map(position: $position, interactionModes: []) {
            Marker(viewModel.name, coordinate: viewModel.region.center)
                .tint(.customPrimary)
        }
        .cornerRadius(Style.LocationRow.cornerRadius)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationRow(viewModel: LocationRowViewModel(
        location: LocationModel.examples.first!,
        service: WeatherService(),
        temperatureRenderer: TemperatureRenderer(),
        measurementSystemNotification: MeasurementSystemNotification()
    ))
}
