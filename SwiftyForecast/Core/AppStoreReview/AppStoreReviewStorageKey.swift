enum AppStoreReviewStorageKey: String {
  case lastReviewVersion
  case locationCounter

  var key: String {
    return self.rawValue
  }
}
