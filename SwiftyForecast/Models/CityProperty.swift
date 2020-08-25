enum CityProperty: String {
  case id
  case name
  case country
  case state
  case postalCode
  case timeZoneName
  case isUserLocation
  case latitude
  case longitude
  
  var key: String {
    return self.rawValue
  }
}
