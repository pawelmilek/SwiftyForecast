//
//  LocationSearchCompleter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import Combine

final class LocationSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
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
            .flatMap { [unowned self] currentSearchQuery in
                self.searchQueryToResults(currentSearchQuery)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("File: \(#file), Function: \(#function)")

                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [weak self] results in
                self?.searchResults = results
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

    func removeAllResults() {
        searchResults.removeAll()
    }
}
