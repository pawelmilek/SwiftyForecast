//
//  SearchedLocationWeatherView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/10/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchedLocationWeatherView: View {
    @ObservedObject var viewModel: SearchedLocationWeatherViewViewModel
    @ObservedObject var cardViewModel: CurrentWeatherCardViewModel
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                CurrentWeatherCard(viewModel: cardViewModel)
                hourlyForecastChartView
                Spacer()
            }
            .padding(.top, 15)
            .padding(.horizontal, 22.5)
            .opacity(viewModel.isLoading ? 0.0 : 1.0)
            .toolbar {
                cancelToolbarItem
                addToolbarItem
            }
            .disabled(viewModel.isLoading)
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .tint(.customPrimary)
                .opacity(viewModel.isLoading ? 1.0 : 0.0)
        }
        .animation(.easeIn, value: viewModel.isLoading)
        .task {
            await viewModel.loadData()
            viewModel.logScreenViewed(className: "\(type(of: self))")
        }
        .onReceive(viewModel.$location.compactMap { $0 }) { location in
            cardViewModel.setLocationModel(location)
        }
    }

    @ToolbarContentBuilder
    private var cancelToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                onCancel()
            } label: {
                Text("Cancel")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }

    @ToolbarContentBuilder
    private var addToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.addLocation()
                onCancel()
            } label: {
                Text("Add")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .disabled(viewModel.addButtonDisabled)
            .opacity(viewModel.addButtonDisabled ? 0.5 : 1.0)
        }
    }

    @ViewBuilder
    private var hourlyForecastChartView: some View {
        if let twentyFourHoursForecast = viewModel.twentyFourHoursForecast {
            HourlyForecastChart(
                viewModel: HourlyForecastChartViewModel(
                    models: twentyFourHoursForecast
                )
            )
        } else {
            EmptyView()
        }
    }
}

#Preview {
    SearchedLocationWeatherView(
        viewModel: SearchedLocationWeatherViewViewModel(
            searchedLocation: MKLocalSearchCompletion(),
            service: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
            databaseManager: RealmManager.shared,
            appStoreReviewCenter: ReviewNotificationCenter(),
            locationPlace: GeocodedLocation(geocoder: CLGeocoder()),
            parser: ResponseParser(),
            analyticsManager: AnalyticsManager(service: FirebaseAnalyticsService())
        ),
        cardViewModel: CurrentWeatherCardViewModel(
            location: LocationModel.examples.first!,
            client: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
            temperatureRenderer: TemperatureRenderer(),
            speedRenderer: SpeedRenderer(),
            measurementSystemNotification: MeasurementSystemNotification()
        ),
        onCancel: {}
    )
}
