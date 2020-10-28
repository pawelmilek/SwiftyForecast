struct ReviewDesirableMomentConfig: Decodable {
  let locationCount: Int
  let detailsInteractionCount: Int
  let minEnjoyableTemperatureInFahrenheit: Int
  let maxEnjoyableTemperatureInFahrenheit: Int
}
