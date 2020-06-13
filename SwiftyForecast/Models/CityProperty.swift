enum CityProperty: String {
  case index
  case name
  case country
  case state
  case postalCode
  case timeZoneName
  case isCurrentLocalization
  case latitude
  case longitude
  
  var key: String {
    return self.rawValue
  }
}
