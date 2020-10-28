import StoreKit

final class AppStoreReviewManager {
  private lazy var lastReviewAppVersion = loadLastReviewVersion() {
    didSet { saveLastReviewVersion() }
  }
  
  private lazy var lastReviewLocationCount = loadReviewLocationCounter() {
    didSet { saveReviewLocationCounter() }
  }
  
  private lazy var lastDetailsInteractionCount = loadReviewDetailsInteractionCounter() {
    didSet { saveReviewDetailsInteractionCounter() }
  }
    
  private var currentAppVersion: String {
    return Bundle.main.releaseVersionNumber
  }
  
  private var minimumReviewWortyLocationCount: Int {
    return desirableMoments.locationCount
  }
  
  private var minimumReviewWortyDetailsInteractionCount: Int {
    return desirableMoments.detailsInteractionCount
  }
  
  private var reviewWortyMinEnjoyableTemperatureInFahrenheit: Int {
    return desirableMoments.minEnjoyableTemperatureInFahrenheit
  }
  
  private var reviewWortyMaxEnjoyableTemperatureInFahrenheit: Int {
    return desirableMoments.maxEnjoyableTemperatureInFahrenheit
  }

  private lazy var desirableMoments: ReviewDesirableMomentConfig = {
    guard let config: ReviewDesirableMomentConfig = try? PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig") else {
      fatalError("File: \(#file), Function: \(#function), line: \(#line)")
    }
    
    return config
  }()
  
  private var currentLocationCount = 0
  private var currentDetailsInteractionCount = 0
  private let storage: UserDefaults
  
  init(storage: UserDefaults = .standard) {
    self.storage = storage
  }
  
  func requestReview(for moment: ReviewDesirableMomentType) {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(currentAppVersion)")
    guard lastReviewAppVersion == InvalidReference.notApplicable || lastReviewAppVersion != currentAppVersion else { return }
    
    switch moment {
    case .detailsInteractionExpanded:
      currentDetailsInteractionCount = lastDetailsInteractionCount
      currentDetailsInteractionCount += 1
      lastDetailsInteractionCount = currentDetailsInteractionCount
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(lastDetailsInteractionCount)")
      
      guard lastDetailsInteractionCount >= minimumReviewWortyDetailsInteractionCount else { return }
      currentDetailsInteractionCount = 0
      lastDetailsInteractionCount = 0
      
    case .locationAdded:
      currentLocationCount = lastReviewLocationCount
      currentLocationCount += 1
      lastReviewLocationCount = currentLocationCount
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(lastReviewLocationCount)")
      
      guard lastReviewLocationCount >= minimumReviewWortyLocationCount else { return }
      currentLocationCount = 0
      lastReviewLocationCount = 0
      
    case .enjoyableOutsideTemperatureReached(let value):
      let min = reviewWortyMinEnjoyableTemperatureInFahrenheit
      let max = reviewWortyMaxEnjoyableTemperatureInFahrenheit
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(value)")
      
      guard (min...max).contains(value) else { return }
    }

    lastReviewAppVersion = currentAppVersion
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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

  func loadReviewDetailsInteractionCounter() -> Int {
    storage.integer(forKey: AppStoreReviewStorageKey.detailsInteractionCounter.key)
  }
  
  func saveReviewDetailsInteractionCounter() {
    storage.set(currentDetailsInteractionCount, forKey: AppStoreReviewStorageKey.detailsInteractionCounter.key)
  }

}
