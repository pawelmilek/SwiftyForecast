struct DailyData: Forecast {
  let date: ForecastDate
  let summary: String
  let icon: String
  let sunriseTime: ForecastDate
  let sunsetTime: ForecastDate
  let temperature: Double = 0
  let apparentTemperature: Double = 0
  let temperatureMin: Double
  let temperatureMinTime: ForecastDate
  let temperatureMax: Double
  let temperatureMaxTime: ForecastDate
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
}

// MARK: - Decodable protocol
extension DailyData: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case sunriseTime
    case sunsetTime
    case temperatureMin
    case temperatureMinTime
    case temperatureMax
    case temperatureMaxTime
    case humidity
    case pressure
    case windSpeed
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.date = try ForecastDate(from: decoder)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    
    let sunriseTimestamp = try container.decode(Int.self, forKey: .sunriseTime)
    let sunsetTimestamp = try container.decode(Int.self, forKey: .sunsetTime)
    self.sunriseTime = ForecastDate(timestamp: sunriseTimestamp)
    self.sunsetTime = ForecastDate(timestamp: sunsetTimestamp)
  
    let temperatureMinTimestamp = try container.decode(Int.self, forKey: .temperatureMinTime)
    let temperatureMaxTimestamp = try container.decode(Int.self, forKey: .temperatureMaxTime)
    self.temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
    self.temperatureMinTime = ForecastDate(timestamp: temperatureMinTimestamp)
    self.temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
    self.temperatureMaxTime = ForecastDate(timestamp: temperatureMaxTimestamp)
    self.humidity = try container.decode(Double.self, forKey: .humidity)
    self.pressure = try container.decode(Double.self, forKey: .pressure)
    self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
  }
}
