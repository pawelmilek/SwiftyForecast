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
    @Published var showSheet = false
    private(set) var searchCompletion: MKLocalSearchCompletion

    init(searchCompletion: MKLocalSearchCompletion = MKLocalSearchCompletion()) {
        self.searchCompletion = searchCompletion
        self.showSheet = showSheet
    }

    func select(_ localSearchCompletion: MKLocalSearchCompletion) {
        searchCompletion = localSearchCompletion
        showSheet.toggle()
    }

    func hideSheet() {
        showSheet.toggle()
    }
}
