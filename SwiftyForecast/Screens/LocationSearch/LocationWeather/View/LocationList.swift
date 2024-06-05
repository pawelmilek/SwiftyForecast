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
    @Environment(\.isSearching) private var isSearching: Bool
    @StateObject private var analyticsManager = AnalyticsManager(service: FirebaseAnalyticsService())

    @Binding var searchText: String
    var onSelectRow: (LocationModel) -> Void
    private let locationsTip = LocationsTip()

    @ObservedResults(
        LocationModel.self,
        configuration: RealmManager.shared.realm.configuration,
        sortDescriptor: SortDescriptor(keyPath: "isUserLocation", ascending: false)
    ) private var locations

    var body: some View {
        List {
            TipView(locationsTip)
                .tint(Color(.customPrimary))
                .listRowSeparator(.hidden)
            ForEach(locations) { location in
                LocationRow(location: location)
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
                LocationSearchResultList()
            }
        }
    }

    private func logLocationSelected(_ name: String) {
        analyticsManager.log(
            event: .locationSelected(name: name)
        )
    }
}

#Preview {
    LocationList(searchText: .constant("Search Text"), onSelectRow: {_ in })
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
