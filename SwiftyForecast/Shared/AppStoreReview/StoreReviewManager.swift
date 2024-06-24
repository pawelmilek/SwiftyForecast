//
//  AppStoreReviewManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

@MainActor
final class StoreReviewManager {
    private let store: StoreReview
    private let storage: ReviewedVersionStorage
    private let bundle: Bundle

    init(store: StoreReview, storage: ReviewedVersionStorage, bundle: Bundle) {
        self.store = store
        self.bundle = bundle
        self.storage = storage
    }

    func requestReview() {
        guard canRequestReview() else { return }
        Task {
            try await Task.sleep(for: .seconds(1))
            store.request()
            storage.save(bundle.versionNumber)
        }
    }

    private func canRequestReview() -> Bool {
        guard let reviewedAppVersion = storage.version() else { return true }
        return bundle.versionNumber != reviewedAppVersion ? true : false
    }
}
