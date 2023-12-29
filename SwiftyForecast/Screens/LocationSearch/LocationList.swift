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
                .tint(Color(uiColor: .primary))
                .listRowSeparator(.hidden)
            ForEach(locations) { location in
                LocationRow(item: location)
                .deleteDisabled(location.isUserLocation)
                .onTapGesture {
                    onSelectRow(location)
                }
            }
            .onDelete(perform: $locations.remove)
        }
        .listStyle(.grouped)
        .overlay {
            if isSearching && !searchText.isEmpty {
                LocationSearchResultList()
            }
        }
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
