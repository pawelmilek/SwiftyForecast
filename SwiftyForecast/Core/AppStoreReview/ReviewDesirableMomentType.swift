enum ReviewDesirableMomentType: Int {
    case locationAdded
    case enjoyableTemperatureReached

    var key: Int {
        self.rawValue
    }
}
