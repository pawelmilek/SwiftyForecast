import RealmSwift

@objcMembers final class CurrentForecast: Object, Decodable {
  dynamic var date: ForecastDate?
  dynamic var summary = ""
  dynamic var icon = ""
  dynamic var temperature = 0.0
  dynamic var humidity = 0.0
  dynamic var pressure = 0.0
  dynamic var windSpeed = 0.0
    
  private enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case temperature
    case apparentTemperature
    case humidity
    case pressure
    case windSpeed
  }
  
  convenience init(date: ForecastDate,
                   summary: String,
                   icon: String,
                   temperature: Double,
                   humidity: Double,
                   pressure: Double,
                   windSpeed: Double) {
    self.init()
    self.date = date
    self.summary = summary
    self.icon = icon
    self.temperature = temperature
    self.humidity = humidity
    self.pressure = pressure
    self.windSpeed = windSpeed
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let date = try ForecastDate(from: decoder)
    let summary = try container.decode(String.self, forKey: .summary)
    let icon = try container.decode(String.self, forKey: .icon)
    let temperature = try container.decode(Double.self, forKey: .temperature)
    let humidity = try container.decode(Double.self, forKey: .humidity)
    let pressure = try container.decode(Double.self, forKey: .pressure)
    let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    
    self.init(date: date,
              summary: summary,
              icon: icon,
              temperature: temperature,
              humidity: humidity,
              pressure: pressure,
              windSpeed: windSpeed)
  }
  
  required init() {
    super.init()
  }
}
