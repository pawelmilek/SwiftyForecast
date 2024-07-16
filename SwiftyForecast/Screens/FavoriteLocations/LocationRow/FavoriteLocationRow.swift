//
//  FavoriteLocationRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct FavoriteLocationRow: View {
    @StateObject private var viewModel: LocationRowViewModel

    init(viewModel: LocationRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
        .task {
            await viewModel.loadData()
        }
    }
}

private extension FavoriteLocationRow {
    struct Style {
        static let backgroundColor = UIColor.clear
        static let timeFont = Font.system(.subheadline, design: .monospaced, weight: .bold)

        static let nameFont = Font.system(.footnote, design: .monospaced, weight: .semibold)
        static let nameColor = Color(.accent)

        static let tempFont = Font.system(.title, design: .monospaced, weight: .heavy)
        static let tempColor = Color(.customPrimary)

        static let cornerRadius = CGFloat(15)
        static let borderColor = Color(.shadow)
        static let shadowColor = Color(.shadow)
        static let shadowRadius = CGFloat(0)
        static let shadowOpacity = Float(1.0)
        static let shadowOffset = (x: 2.5, y: 2.5)
    }

    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.time)
                    .font(Style.timeFont)
                    .foregroundStyle(.customPrimary)
                Text(viewModel.name)
                    .font(Style.nameFont)
                    .foregroundStyle(Style.nameColor)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.temperature)
                .font(Style.tempFont)
                .foregroundStyle(Style.tempColor)
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
        .cornerRadius(Style.cornerRadius)
        .clipShape(
            RoundedRectangle(
                cornerRadius: Style.cornerRadius,
                style: .continuous
            )
            .inset(by: 2.5)
        )
        .shadow(
            color: Style.shadowColor,
            radius: Style.shadowRadius,
            x: Style.shadowOffset.x,
            y: Style.shadowOffset.y
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FavoriteLocationRow(
        viewModel: LocationRowViewModel(
            location: LocationModel.examples.first!,
            service: WeatherService(
                repository: WeatherRepository(
                    client: OpenWeatherClient(
                        decoder: JSONSnakeCaseDecoded()
                    )
                ),
                parse: WeatherResponseParser()
            ),
            temperatureFormatterFactory: TemperatureFormatterFactory(notationStorage: NotationSettingsStorage())
        )
    )
}
