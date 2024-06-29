//
//  FavoriteLocationList.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/21/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import RealmSwift
import TipKit

struct FavoriteLocationList: View {
    @Environment(\.service) private var service
    @Environment(\.isSearching) private var isSearching
    @Environment(\.databaseManager) private var databaseManager
    @Environment(\.analyticsService) private var analyticsService
    @Binding var searchText: String
    var onSelectRow: (Int) -> Void

    @ObservedResults(
        LocationModel.self,
        configuration: RealmManager().realm.configuration,
        sortDescriptor: SortDescriptor(keyPath: "isUserLocation", ascending: false)
    ) private var locations

    var body: some View {
        List {
            TipView(LocationsTip())
                .tint(.customPrimary)
                .listRowSeparator(.hidden)
            ForEach(Array(zip(locations.indices, locations)), id: \.0) { index, location in
                FavoriteLocationRow(
                    viewModel: .init(
                        location: location,
                        service: service,
                        temperatureFormatterFactory: TemperatureFormatterFactory(notationStorage: NotationSettingsStorage())
                    )
                )
                .listRowSeparator(.hidden)
                .deleteDisabled(location.isUserLocation)
                .onTapGesture {
                    onSelectRow(index)
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
        analyticsService.send(
            event: LocationListEvent.locationSelected(
                name: name
            )
        )
    }
}

#Preview {
    FavoriteLocationList(
        searchText: .constant("Search Text"),
        onSelectRow: { _ in }
    )
    .task {
        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
