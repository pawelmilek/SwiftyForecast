import Foundation
import RealmSwift

@objcMembers final class HourlyData: Object, Decodable {
  dynamic var date = Date()
  dynamic var summary = ""
  dynamic var icon = ""
  dynamic var precipIntensity = 0.0
  dynamic var precipProbability = 0.0
  dynamic var temperature = 0.0
  dynamic var apparentTemperature = 0.0
  dynamic var dewPoint = 0.0
  dynamic var humidity = 0.0
  dynamic var pressure = 0.0
  dynamic var windSpeed = 0.0
  dynamic var windGust = 0.0
  dynamic var windBearing = 0.0
  dynamic var cloudCover = 0.0
  dynamic var visibility = 0.0
  dynamic var ozone = 0.0
  
  private enum CodingKeys: String, CodingKey {
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
    case time
  }
  
  convenience init(date: Date,
                   summary: String,
                   icon: String,
                   precipIntensity: Double,
                   precipProbability: Double,
                   temperature: Double,
                   apparentTemperature: Double,
                   dewPoint: Double,
                   humidity: Double,
                   pressure: Double,
                   windSpeed: Double,
                   windGust: Double,
                   windBearing: Double,
                   cloudCover: Double,
                   visibility: Double,
                   ozone: Double) {
    self.init()
    self.date = date
    self.summary = summary
    self.icon = icon
    self.precipIntensity = precipIntensity
    self.precipProbability = precipProbability
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
    self.dewPoint = dewPoint
    self.humidity = humidity
    self.pressure = pressure
    self.windSpeed = windSpeed
    self.windGust = windGust
    self.windBearing = windBearing
    self.cloudCover = cloudCover
    self.visibility = visibility
    self.ozone = ozone
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timeInterval = try container.decode(Int.self, forKey: .time)
    let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
    let summary = try container.decode(String.self, forKey: .summary)
    let icon = try container.decode(String.self, forKey: .icon)
    let precipIntensity = try container.decode(Double.self, forKey: .precipIntensity)
    let precipProbability = try container.decode(Double.self, forKey: .precipProbability)
    let temperature = try container.decode(Double.self, forKey: .temperature)
    let apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
    let dewPoint = try container.decode(Double.self, forKey: .dewPoint)
    let humidity = try container.decode(Double.self, forKey: .humidity)
    let pressure = try container.decode(Double.self, forKey: .pressure)
    let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    let windGust = try container.decode(Double.self, forKey: .windGust)
    let windBearing = try container.decode(Double.self, forKey: .windBearing)
    let cloudCover = try container.decode(Double.self, forKey: .cloudCover)
    let visibility = try container.decode(Double.self, forKey: .visibility)
    let ozone = try container.decode(Double.self, forKey: .ozone)
    
    self.init(date: date,
              summary: summary,
              icon: icon,
              precipIntensity: precipIntensity,
              precipProbability: precipProbability,
              temperature: temperature,
              apparentTemperature: apparentTemperature,
              dewPoint: dewPoint,
              humidity: humidity,
              pressure: pressure,
              windSpeed: windSpeed,
              windGust: windGust,
              windBearing: windBearing,
              cloudCover: cloudCover,
              visibility: visibility,
              ozone: ozone)
  }
  
  required init() {
    super.init()
  }
}
