//
//  LocationWeatherView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/10/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationWeatherView: View {
    @ObservedObject var viewModel: LocationWeatherViewViewModel
    @StateObject private var cardViewModel = CurrentWeatherCardViewModel()

    var onDismissSearch: () -> Void

    @State private var opacity = 0.0
    @State private var toolbarAddItemOpacity = 0.0
    @State private var isToolbarDisabled = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                CurrentWeatherCard(viewModel: cardViewModel)
                if viewModel.shouldShowHourlyForecastChart {
                    HourlyForecastChart(
                        viewModel: HourlyForecastChartViewModel(models: viewModel.twentyFourHoursForecastModel)
                    )
                }
                Spacer()
            }
            .padding(.top, 15)
            .padding(.horizontal, 22.5)
            .opacity(opacity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onDismissSearch()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.accent)
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addNewLocation()
                        onDismissSearch()
                    } label: {
                        Text("Add")
                            .foregroundStyle(.accent)
                            .fontDesign(.monospaced)
                            .fontWeight(.semibold)
                    }
                    .opacity(toolbarAddItemOpacity)
                }
            }
            .disabled(isToolbarDisabled)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.startSearchRequest()
            viewModel.logScreenViewed(className: "\(type(of: self))")
        }
        .onChange(of: viewModel.isLoading) {
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = viewModel.isLoading == true ? 0.0 : 1.0
                isToolbarDisabled = viewModel.isLoading
            }
        }
        .onChange(of: viewModel.location) {
            guard let location = viewModel.location else { return }
            cardViewModel.setLocationModel(location)
        }
        .onChange(of: viewModel.isExistingLocation) {
            toolbarAddItemOpacity = viewModel.isExistingLocation == true ? 0.0 : 1.0
        }
    }
}

#Preview {
    LocationWeatherView(viewModel: .init(searchCompletion: MKLocalSearchCompletion()),
                        onDismissSearch: {
    }
    )
}
