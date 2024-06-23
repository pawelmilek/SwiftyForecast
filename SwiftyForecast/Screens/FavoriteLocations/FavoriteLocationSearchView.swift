//
//  FavoriteLocationSearchView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct FavoriteLocationSearchView: View {
    @StateObject private var searchCompleter = LocationSearchCompleter()
    var onDidSelectLocation: (Int) -> Void

    var body: some View {
        NavigationStack {
            FavoriteLocationList(
                searchText: $searchCompleter.searchText,
                temperatureFormatterFactory: TemperatureFormatterFactory(
                    notationStorage: NotationSystemStorage()
                ),
                onSelectRow: onDidSelectLocation
            )
            .environment(\.locationSearchCompleter, searchCompleter)
            .navigationTitle("Locations")
        }
        .searchable(
            text: $searchCompleter.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search for a city or address")
        )
        .autocorrectionDisabled()
    }
}

#Preview {
    FavoriteLocationSearchView() { _ in }
}
