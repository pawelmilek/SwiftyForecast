//
//  LocationList.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import RealmSwift
import TipKit

struct LocationList: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.analyticsManager) private var analyticsManager
    @Environment(\.weatherClient) private var weatherClient
    @Binding var searchText: String
    let temperatureRenderer: TemperatureRenderer
    let measurementSystemNotification: MeasurementSystemNotification
    var onSelectRow: (LocationModel) -> Void

    @ObservedResults(
        LocationModel.self,
        configuration: RealmManager.shared.realm.configuration,
        sortDescriptor: SortDescriptor(keyPath: "isUserLocation", ascending: false)
    ) private var locations

    var body: some View {
        List {
            TipView(LocationsTip())
                .tint(.customPrimary)
                .listRowSeparator(.hidden)
            ForEach(locations) { location in
                LocationRow(
                    viewModel: LocationRowViewModel(
                        location: location,
                        client: weatherClient,
                        parser: ResponseParser(),
                        temperatureRenderer: temperatureRenderer,
                        measurementSystemNotification: measurementSystemNotification
                    )
                )
                .listRowSeparator(.hidden)
                .deleteDisabled(location.isUserLocation)
                .onTapGesture {
                    onSelectRow(location)
                    logLocationSelected(location.name + ", " + location.country)
                }
            }
            .onDelete(perform: $locations.remove)
        }
        .listStyle(.plain)
        .overlay {
            if isSearching && !searchText.isEmpty {
                LocationSearchResults()
            }
        }
    }

    private func logLocationSelected(_ name: String) {
        analyticsManager.send(
            event: LocationListEvent.locationSelected(
                name: name
            )
        )
    }
}

#Preview {
    LocationList(
        searchText: .constant("Search Text"),
        temperatureRenderer: TemperatureRenderer(),
        measurementSystemNotification: MeasurementSystemNotification(),
        onSelectRow: {_ in }
    )
    .task {
        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
