struct CurrentForecast: Forecast {
  let date: ForecastDate
  let summary: String
  let icon: String
  let temperature: Double
  let apparentTemperature: Double
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
}

// MARK: - Temperature in Celsius
extension CurrentForecast {
  
  var temperatureFormatted: String {
    if NotationSystem.selectedUnitNotation == .metric {
      let temperatureInCelsius = temperature.ToCelsius()
      return temperatureInCelsius.roundedToString + Style.degreeSign
    } else {
      return temperature.roundedToString + Style.degreeSign
    }
  }
  
}

// MARK: - Decodable protocol
extension CurrentForecast: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case temperature
    case apparentTemperature
    case humidity
    case pressure
    case windSpeed
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.date = try ForecastDate(from: decoder)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.temperature = try container.decode(Double.self, forKey: .temperature)
    self.apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
    self.humidity = try container.decode(Double.self, forKey: .humidity)
    self.pressure = try container.decode(Double.self, forKey: .pressure)
    self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
  }
}
