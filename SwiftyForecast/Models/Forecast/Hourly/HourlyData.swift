struct HourlyData: Forecast {
  let date: ForecastDate
  let summary: String
  let icon: String
  let precipIntensity: Double
  let precipProbability: Double
  let temperature: Double
  let apparentTemperature: Double
  let dewPoint: Double
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
  let windGust: Double
  let windBearing: Double
  let cloudCover: Double
  let visibility: Double
  let ozone: Double
}

// MARK: - Decodable protocol
extension HourlyData: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case precipIntensity
    case precipProbability
    case temperature
    case apparentTemperature
    case dewPoint
    case humidity
    case pressure
    case windSpeed
    case windGust
    case windBearing
    case cloudCover
    case visibility
    case ozone
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.date = try ForecastDate(from: decoder)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.precipIntensity = try container.decode(Double.self, forKey: .precipIntensity)
    self.precipProbability = try container.decode(Double.self, forKey: .precipProbability)
    self.temperature = try container.decode(Double.self, forKey: .temperature)
    self.apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
    self.dewPoint = try container.decode(Double.self, forKey: .dewPoint)
    self.humidity = try container.decode(Double.self, forKey: .humidity)
    self.pressure = try container.decode(Double.self, forKey: .pressure)
    self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    self.windGust = try container.decode(Double.self, forKey: .windGust)
    self.windBearing = try container.decode(Double.self, forKey: .windBearing)
    self.cloudCover = try container.decode(Double.self, forKey: .cloudCover)
    self.visibility = try container.decode(Double.self, forKey: .visibility)
    self.ozone = try container.decode(Double.self, forKey: .ozone)
  }
}
