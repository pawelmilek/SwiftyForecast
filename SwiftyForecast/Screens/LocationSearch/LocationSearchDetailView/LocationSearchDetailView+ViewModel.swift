//
//  LocationSearchDetailView+ViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import SwiftUI
import RealmSwift

extension LocationSearchDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var error: Error?
        @Published var position = MapCameraPosition.automatic
        @Published private(set) var isLoading = true
        @Published private(set) var isNewLocationAdded = false
        @Published private(set) var title = ""
        @Published private(set) var subtitle = ""
        @Published private(set) var time = ""
        @Published private(set) var coordinate = CLLocationCoordinate2D()

        private let searchResult: MKLocalSearchCompletion
        private let locationDAO: LocationDataAccessObject
        private let appStoreReviewCenter: AppStoreReviewCenter
        private var newLocation = LocationModel()

        init(searchResult: MKLocalSearchCompletion,
             locationDAO: LocationDataAccessObject = LocationDataAccessObject(),
             appStoreReviewCenter: AppStoreReviewCenter = AppStoreReviewCenter()) {
            self.searchResult = searchResult
            self.locationDAO = locationDAO
            self.appStoreReviewCenter = appStoreReviewCenter
            debugPrint("LocationSearchDetailView.ViewModel init")
        }

        func startSearchRequest() {
            let searchRequest = MKLocalSearch.Request(completion: searchResult)
            let search = MKLocalSearch(request: searchRequest)
            isLoading = true

            Task(priority: .userInitiated) {
                do {
                    let response = try await search.start()
                    if let location = response.mapItems.first?.placemark.location {
                        let placemark = try await Geocoder.fetchPlacemark(at: location)

                        let region = MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )

                        self.position = MapCameraPosition.region(region)
                        self.newLocation = LocationModel(placemark: placemark)
                        self.title = self.newLocation.name
                        self.subtitle = self.newLocation.country
                        self.time = Date.timeOnly(from: self.newLocation.secondsFromGMT)
                        self.coordinate = placemark.location!.coordinate
                        self.isLoading = false
                    } else {
                        throw GeocoderError.coordinateNotFound
                    }
                } catch {
                    self.error = error as? GeocoderError
                    self.isLoading = false
                }
            }
        }

        func addNewLocation() {
            do {
                if isNewLocationExist {
                    try locationDAO.update(newLocation)
                } else {
                    try locationDAO.create(newLocation)
                }
                appStoreReviewCenter.post(.locationAdded)

            } catch {
                fatalError("Error: Unexpected Realm \(RealmError.initializationFailed)")
            }
        }

        private var isNewLocationExist: Bool {
            locationDAO.checkExistanceByCompoundKey(newLocation)
        }
    }
}
