enum CityProperty: String {
  case orderIndex
  case compoundKey
  case name
  case country
  case state
  case postalCode
  case timeZoneIdentifier
  case lastUpdate
  case isUserLocation
  case latitude
  case longitude
  
  var key: String {
    return self.rawValue
  }
}
