import StoreKit

final class AppStoreReviewManager {
    private lazy var lastReviewAppVersion = loadLastReviewVersion() {
        didSet { saveLastReviewVersion() }
    }

    private lazy var lastReviewLocationCount = loadReviewLocationCounter() {
        didSet { saveReviewLocationCounter() }
    }

    private var currentAppVersion: String {
        return Bundle.main.releaseVersionNumber
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

    init(storage: UserDefaults = .standard) {
        self.storage = storage
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            SKStoreReviewController.requestReview(in: <#T##UIWindowScene#>)
            SKStoreReviewController.requestReview()
        }
    }

}

// MARK: - Private - Storage data access object helpers
private extension AppStoreReviewManager {

    func loadLastReviewVersion() -> String {
        storage.string(forKey: AppStoreReviewStorageKey.lastReviewVersion.key) ?? InvalidReference.notApplicable
    }

    func saveLastReviewVersion() {
        storage.set(currentAppVersion, forKey: AppStoreReviewStorageKey.lastReviewVersion.key)
    }

    func loadReviewLocationCounter() -> Int {
        storage.integer(forKey: AppStoreReviewStorageKey.locationCounter.key)
    }

    func saveReviewLocationCounter() {
        storage.set(currentLocationCount, forKey: AppStoreReviewStorageKey.locationCounter.key)
    }

}
