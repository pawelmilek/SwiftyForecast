extension Double {
  
  var roundedToString: String {
    return String(format: "%.0f", self.rounded(.awayFromZero))
  }
  
}
