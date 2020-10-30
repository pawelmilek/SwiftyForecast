enum NotationType: String {
  case unit
  case temperature
  
  var key: String {
    return self.rawValue
  }
}
