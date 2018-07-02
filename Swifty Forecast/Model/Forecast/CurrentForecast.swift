//
//  CurrentForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct CurrentForecast: Forecast {
  var time: ForecastDate
  var summary: String
  var icon: String
  var precipIntensity: Double
  var precipProbability: Double
  var temperature: Double
  var apparentTemperature: Double
  var dewPoint: Double
  var humidity: Double
  var pressure: Double
  var windSpeed: Double
  var windGust: Double
  var windBearing: Double
  var cloudCover: Double
  var uvIndex: Int
  var visibility: Double
  var ozone: Double
  let nearestStormDistance: Int
  let nearestStormBearing: Int
}


// MARK: - Temperature in Celsius
extension CurrentForecast {
  
  var temperatureInCelsius: Double {
    return (temperature - 32) * Double(5.0 / 9.0)
  }
  
}



// MARK: - Decodable protocol
extension CurrentForecast: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case time
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
    case uvIndex
    case visibility
    case ozone
    case nearestStormDistance
    case nearestStormBearing
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timestamp = try container.decode(Int.self, forKey: .time)
    self.time = ForecastDate(timestamp: timestamp)
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
    self.uvIndex = try container.decode(Int.self, forKey: .uvIndex)
    self.visibility = try container.decode(Double.self, forKey: .visibility)
    self.ozone = try container.decode(Double.self, forKey: .ozone)
    self.nearestStormDistance = try container.decode(Int.self, forKey: .nearestStormDistance)
    self.nearestStormBearing = try container.decode(Int.self, forKey: .nearestStormBearing)
  }
}
