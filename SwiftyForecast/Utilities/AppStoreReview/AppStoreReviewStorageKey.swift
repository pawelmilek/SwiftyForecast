enum AppStoreReviewStorageKey: String {
  case lastReviewVersion
  case locationCounter
  case detailsInteractionCounter
  
  var key: String {
    return self.rawValue
  }
}
