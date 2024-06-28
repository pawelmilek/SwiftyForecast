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
    @ObservedObject var cardViewModel: WeatherCardViewViewModel
    var onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                WeatherCardView(viewModel: cardViewModel)
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
        viewModel: CompositionRoot.searchedLocationWeatherViewModel(
            LocationModel.examples.first!
        ),
        cardViewModel: CompositionRoot.cardViewModel(
            latitude: LocationModel.examples.first!.latitude,
            longitude: LocationModel.examples.first!.longitude,
            name: LocationModel.examples.first!.name
        ),
        onCancel: {
        }
    )
}
