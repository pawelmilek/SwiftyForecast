//
//  LocationRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationRow: View {
    @StateObject var viewModel: LocationRowViewModel

    init(location: LocationModel) {
        _viewModel = StateObject(wrappedValue: LocationRowViewModel(
            location: location,
            service: WeatherService(decoder: JSONDecoder()),
            temperatureRenderer: TemperatureRenderer(),
            measurementSystemNotification: MeasurementSystemNotification()
        ))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            headerView
            mapView
        }
        .padding(8)
        .frame(minHeight: 145, maxHeight: 145)
        .fixedSize(horizontal: false, vertical: true)
        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
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
        Map(position: $viewModel.position, interactionModes: []) {
            if let center = viewModel.position.region?.center {
                Marker(viewModel.name, coordinate: center)
                    .tint(.customPrimary)
            }
        }
        .cornerRadius(Style.LocationRow.cornerRadius)
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
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationRow(location: LocationModel.examples.first!)
}
