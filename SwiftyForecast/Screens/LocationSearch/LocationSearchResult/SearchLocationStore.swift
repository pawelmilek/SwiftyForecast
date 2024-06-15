//
//  SearchLocationStore.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/17/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import MapKit

@MainActor
class SearchLocationStore: ObservableObject {
    @Published var foundLocation: LocationModel?
    private let locationPlace: LocationPlaceable

    init(locationPlace: LocationPlaceable) {
        self.locationPlace = locationPlace
    }

    func select(_ localSearch: MKLocalSearchCompletion) async {
        await fetchLocation(localSearch)
    }

    func clearFoundLocation() {
        foundLocation = nil
    }

    private func fetchLocation(_ localSearch: MKLocalSearchCompletion) async {
        let searchRequest = MKLocalSearch(
            request: MKLocalSearch.Request(
                completion: localSearch
            )
        )

        do {
            let response = try await searchRequest.start()
            if let responseLocation = response.mapItems.first?.placemark.location {
                foundLocation = try await geocode(location: responseLocation)
            } else {
                throw LocalSearchError.notFound
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func geocode(location: CLLocation) async throws -> LocationModel {
        let placemark = try await locationPlace.placemark(at: location)
        return LocationModel(placemark: placemark, isUserLocation: false)
    }
}
