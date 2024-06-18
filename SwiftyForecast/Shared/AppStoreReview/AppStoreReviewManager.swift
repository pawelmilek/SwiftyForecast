//
//  AppStoreReviewManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import StoreKit

@MainActor
final class AppStoreReviewManager {
    private enum Key: String {
        case lastReviewVersion
        var key: String { self.rawValue }
    }

    private var currentAppVersion: String {
        bundle.versionNumber
    }

    private var currentLocationCount = 0
    private let storage: UserDefaults
    private let bundle: Bundle

    init(bundle: Bundle, storage: UserDefaults) {
        self.bundle = bundle
        self.storage = storage
    }

    func request() {
        let lastReviewAppVersion = loadLastReviewVersion()
        guard (lastReviewAppVersion == InvalidReference.notApplicable) || (currentAppVersion != lastReviewAppVersion) else {
            return
        }

        saveLastReviewVersion()
        requestReview()
    }

    private func loadLastReviewVersion() -> String {
        storage.string(forKey: Key.lastReviewVersion.key) ?? InvalidReference.notApplicable
    }

    private func saveLastReviewVersion() {
        storage.set(currentAppVersion, forKey: Key.lastReviewVersion.key)
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
