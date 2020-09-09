import Foundation
import RealmSwift

@objcMembers final class DailyData: Object, Decodable {
  dynamic var date = Date()
  dynamic var summary = ""
  dynamic var icon = ""
  dynamic var sunriseTime = Date()
  dynamic var sunsetTime = Date()
  dynamic var temperatureMin = 0.0
  dynamic var temperatureMinTime = Date()
  dynamic var temperatureMax = 0.0
  dynamic var temperatureMaxTime = Date()
  dynamic var humidity = 0.0
  dynamic var pressure = 0.0
  dynamic var windSpeed = 0.0
  
  private enum CodingKeys: String, CodingKey {
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
    case time
  }
  
  convenience init(date: Date,
                   summary: String,
                   icon: String,
                   sunriseTime: Date,
                   sunsetTime: Date,
                   temperatureMin: Double,
                   temperatureMinTime: Date,
                   temperatureMax: Double,
                   temperatureMaxTime: Date,
                   humidity: Double,
                   pressure: Double,
                   windSpeed: Double) {
    self.init()
    self.date = date
    self.summary = summary
    self.icon = icon
    self.sunriseTime = sunriseTime
    self.sunsetTime = sunsetTime
    self.temperatureMin = temperatureMin
    self.temperatureMinTime = temperatureMinTime
    self.temperatureMax = temperatureMax
    self.temperatureMaxTime = temperatureMaxTime
    self.humidity = humidity
    self.pressure = pressure
    self.windSpeed = windSpeed
  }
  
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timeInterval = try container.decode(Int.self, forKey: .time)
    let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
    let summary = try container.decode(String.self, forKey: .summary)
    let icon = try container.decode(String.self, forKey: .icon)
    
    let sunriseTimestamp = try container.decode(Int.self, forKey: .sunriseTime)
    let sunsetTimestamp = try container.decode(Int.self, forKey: .sunsetTime)
    let sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunriseTimestamp))
    let sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunsetTimestamp))
    
    let temperatureMinTimestamp = try container.decode(Int.self, forKey: .temperatureMinTime)
    let temperatureMaxTimestamp = try container.decode(Int.self, forKey: .temperatureMaxTime)
    let temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
    let temperatureMinTime = Date(timeIntervalSince1970: TimeInterval(temperatureMinTimestamp))
    let temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
    let temperatureMaxTime = Date(timeIntervalSince1970: TimeInterval(temperatureMaxTimestamp))
    let humidity = try container.decode(Double.self, forKey: .humidity)
    let pressure = try container.decode(Double.self, forKey: .pressure)
    let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
    
    self.init(date: date,
              summary: summary,
              icon: icon,
              sunriseTime: sunriseTime,
              sunsetTime: sunsetTime,
              temperatureMin: temperatureMin,
              temperatureMinTime: temperatureMinTime,
              temperatureMax: temperatureMax,
              temperatureMaxTime: temperatureMaxTime,
              humidity: humidity,
              pressure: pressure,
              windSpeed: windSpeed)
  }
  
  required init() {
    super.init()
  }
}
