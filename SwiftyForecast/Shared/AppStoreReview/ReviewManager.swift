//
//  ReviewManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import StoreKit

@MainActor
final class ReviewManager {
    private enum Key: String {
        case lastReviewVersion
        case locationCounter

        var key: String { self.rawValue }
    }

    private lazy var lastReviewAppVersion = loadLastReviewVersion() {
        didSet { saveLastReviewVersion() }
    }

    private lazy var lastReviewLocationCount = loadReviewLocationCounter() {
        didSet { saveReviewLocationCounter() }
    }

    private var currentAppVersion: String {
        return bundle.versionNumber
    }

    private var reviewWortyLocationCount: Int {
        return desirableMoments.locationCount
    }

    private var reviewWortyEnjoyableTemperatureCount: Int {
        return desirableMoments.enjoyableTemperatureCount
    }

    private lazy var desirableMoments: ReviewDesirableMomentConfig = {
        do {
            let config = try decodePlist.plist(ofType: ReviewDesirableMomentConfig.self)
            return config
        } catch {
            fatalError("File: \(#file), Function: \(#function), line: \(#line)")
        }
    }()

    private var currentLocationCount = 0
    private let storage: UserDefaults
    private let bundle: Bundle
    private let decodePlist: DecodedPlist

    convenience init() {
        self.init(
            bundle: .main,
            storage: .standard,
            decodePlist: DecodedPlist(name: "ReviewDesirableMomentConfig", bundle: .main)
        )
    }

    convenience init(bundle: Bundle, storage: UserDefaults) {
        self.init(
            bundle: bundle,
            storage: storage,
            decodePlist: DecodedPlist(name: "ReviewDesirableMomentConfig", bundle: bundle)
        )
    }

    init(bundle: Bundle, storage: UserDefaults, decodePlist: DecodedPlist) {
        self.bundle = bundle
        self.storage = storage
        self.decodePlist = decodePlist
    }

    func requestReview(for moment: ReviewDesirableMomentType) {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(currentAppVersion)")
        guard (lastReviewAppVersion == InvalidReference.notApplicable)
                || (currentAppVersion != lastReviewAppVersion) else {
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
        requestReview()
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

// MARK: - Private - Storage data
private extension ReviewManager {

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
