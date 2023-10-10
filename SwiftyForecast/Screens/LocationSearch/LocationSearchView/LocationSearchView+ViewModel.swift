//
//  LocationSearchView+ViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import Combine

extension LocationSearchView {
    final class ViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
        @Published var searchResults: [MKLocalSearchCompletion] = []
        @Published var searchText = ""

        private var cancellables: Set<AnyCancellable> = []
        private var searchCompleter = MKLocalSearchCompleter()
        private var currentPromise: ((Result<[MKLocalSearchCompletion], Error>) -> Void)?

        override init() {
            super.init()
            searchCompleter.delegate = self
            searchCompleter.resultTypes = .address

            $searchText
                .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
                .removeDuplicates()
                .flatMap { currentSearchQuery in
                    self.searchQueryToResults(currentSearchQuery)
                }
                .sink(receiveCompletion: { _ in
                    // handle error
                }, receiveValue: { results in
                    self.searchResults = results
                })
                .store(in: &cancellables)
        }

        private func searchQueryToResults(_ query: String) -> Future<[MKLocalSearchCompletion], Error> {
            Future { promise in
                self.searchCompleter.queryFragment = query
                self.currentPromise = promise
            }
        }

        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            currentPromise?(.success(completer.results))
        }

        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
             // Could deal with the error here, but beware that it will finish the Combine publisher stream
             // currentPromise?(.failure(error))
        }
    }
}
