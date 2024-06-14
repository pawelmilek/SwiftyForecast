//
//  LocationSearchResultConfiguration.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import MapKit

class LocationSearchResultConfiguration: ObservableObject {
    @Published var showSearchedLocationForecast = false
    private(set) var localSearch: MKLocalSearchCompletion

    init(localSearch: MKLocalSearchCompletion) {
        self.localSearch = localSearch
        self.showSearchedLocationForecast = showSearchedLocationForecast
    }

    func select(_ localSearchCompletion: MKLocalSearchCompletion) {
        localSearch = localSearchCompletion
        showSearchedLocationForecast.toggle()
    }

    func hideSheet() {
        showSearchedLocationForecast.toggle()
    }
}
