//
//  AppStoreReviewManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import StoreKit

final class AppStoreReviewManager {
    enum Key: String {
        case lastReviewVersion
        case locationCounter

        var key: String {
            return self.rawValue
        }
    }

    private lazy var lastReviewAppVersion = loadLastReviewVersion() {
        didSet { saveLastReviewVersion() }
    }

    private lazy var lastReviewLocationCount = loadReviewLocationCounter() {
        didSet { saveReviewLocationCounter() }
    }

    private var currentAppVersion: String {
        return Bundle.versionNumber
    }

    private var reviewWortyLocationCount: Int {
        return desirableMoments.locationCount
    }

    private var reviewWortyEnjoyableTemperatureCount: Int {
        return desirableMoments.enjoyableTemperatureCount
    }

    private lazy var desirableMoments: ReviewDesirableMomentConfig = {
        do {
            let config = try PlistFileLoader.loadFile(
                with: "ReviewDesirableMomentConfig",
                model: ReviewDesirableMomentConfig.self
            )
            return config
        } catch {
            fatalError("File: \(#file), Function: \(#function), line: \(#line)")
        }
    }()

    private var currentLocationCount = 0
    private let storage: UserDefaults
    private var reviewObserver: Observer

    init(
        storage: UserDefaults = .standard,
        reviewObserver: Observer = ReviewObserver()
    ) {
        self.storage = storage
        self.reviewObserver = reviewObserver
    }

    func requestReview(for moment: ReviewDesirableMomentType) {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(currentAppVersion)")
        guard (lastReviewAppVersion == InvalidReference.notApplicable) ||
                (lastReviewAppVersion != currentAppVersion) else {
            return
        }

        switch moment {
        case .locationAdded:
            currentLocationCount = lastReviewLocationCount
            currentLocationCount += 1
            lastReviewLocationCount = currentLocationCount
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(lastReviewLocationCount)")

            guard lastReviewLocationCount >= reviewWortyLocationCount else { return }
            currentLocationCount = 0
            lastReviewLocationCount = 0

        case .enjoyableTemperatureReached:
            debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
        }

        lastReviewAppVersion = currentAppVersion

        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    func startObserving() {
        reviewObserver.startObserving()
    }

    func stopObserving() {
        reviewObserver.stopObserving()
    }

    func setEventResponderDelegate(_ delegate: ReviewObserverEventResponder) {
        reviewObserver.eventResponder = delegate
    }

}

// MARK: - Private - Storage data access object helpers
private extension AppStoreReviewManager {

    func loadLastReviewVersion() -> String {
        storage.string(forKey: Key.lastReviewVersion.key) ?? InvalidReference.notApplicable
    }

    func saveLastReviewVersion() {
        storage.set(currentAppVersion, forKey: Key.lastReviewVersion.key)
    }

    func loadReviewLocationCounter() -> Int {
        storage.integer(forKey: Key.locationCounter.key)
    }

    func saveReviewLocationCounter() {
        storage.set(currentLocationCount, forKey: Key.locationCounter.key)
    }

}
