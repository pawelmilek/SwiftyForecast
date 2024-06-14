//
//  LocationSearchView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct LocationSearchView: View {
    @StateObject private var locationSearchCompleter = LocationSearchCompleter()
    var onDidSelectLocation: (LocationModel) -> Void

    var body: some View {
        NavigationStack {
            LocationList(
                searchText: $locationSearchCompleter.searchText,
                onSelectRow: onDidSelectLocation
            )
            .environmentObject(locationSearchCompleter)
            .navigationTitle("Locations")
        }
        .searchable(
            text: $locationSearchCompleter.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search for a city or address")
        )
        .autocorrectionDisabled()
    }
}

#Preview {
    LocationSearchView { _ in }
}
