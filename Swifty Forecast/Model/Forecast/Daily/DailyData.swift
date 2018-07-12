//
//  DailyData.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct DailyData: Forecast {
  var date: ForecastDate
  var summary: String
  var icon: String
  
  var sunriseTime: ForecastDate
  var sunsetTime: ForecastDate
  var moonPhase: MoonPhase
  var precipIntensity: Double
  var precipProbability: Double
  
  var temperature: Double = 0
  var apparentTemperature: Double = 0
  
  var precipType: String?
  var temperatureMin: Double
  var temperatureMinTime: ForecastDate
  var temperatureMax: Double
  var temperatureMaxTime: ForecastDate
  
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
}


// MARK: - isMetricMeasuringSystem
extension DailyData {
  
  private var temperatureInCelsiusMin: Double {
    return (temperatureMin - 32) * Double(5.0 / 9.0)
  }
  
  private var temperatureInCelsiusMax: Double {
    return (temperatureMax - 32) * Double(5.0 / 9.0)
  }
  
  var temperatureMinFormatted: String {
    if MeasuringSystem.isMetric {
      return temperatureInCelsiusMin.convertedToString + "\u{00B0}"
    } else {
      return temperatureMin.convertedToString + "\u{00B0}"
    }
  }
  
  var temperatureMaxFormatted: String {
    if MeasuringSystem.isMetric {
      return temperatureInCelsiusMax.convertedToString + "\u{00B0}"
    } else {
      return temperatureMax.convertedToString + "\u{00B0}"
    }
  }
  
}


// MARK: - Decodable protocol
extension DailyData: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case date = "time"
    case summary
    case icon
    
    case sunriseTime
    case sunsetTime
    case moonPhase
    
    case precipIntensity
    case precipProbability
    
    case precipType
    case temperatureMin
    case temperatureMinTime
    case temperatureMax
    case temperatureMaxTime
    
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
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timestamp = try container.decode(Int.self, forKey: .date)
    self.date = ForecastDate(timestamp: timestamp)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    
    let sunriseTimestamp = try container.decode(Int.self, forKey: .sunriseTime)
    let sunsetTimestamp = try container.decode(Int.self, forKey: .sunsetTime)
    self.sunriseTime = ForecastDate(timestamp: sunriseTimestamp)
    self.sunsetTime = ForecastDate(timestamp: sunsetTimestamp)
    
    let moonPhaseLunation = try container.decode(Float.self, forKey: .moonPhase)
    self.moonPhase = MoonPhase(lunation: moonPhaseLunation)
    
    self.precipIntensity = try container.decode(Double.self, forKey: .precipIntensity)
    self.precipProbability = try container.decode(Double.self, forKey: .precipProbability)
    
    self.precipType = try container.decodeIfPresent(String.self, forKey: .precipType)
    
    let temperatureMinTimestamp = try container.decode(Int.self, forKey: .temperatureMinTime)
    let temperatureMaxTimestamp = try container.decode(Int.self, forKey: .temperatureMaxTime)
    self.temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
    self.temperatureMinTime = ForecastDate(timestamp: temperatureMinTimestamp)
    self.temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
    self.temperatureMaxTime = ForecastDate(timestamp: temperatureMaxTimestamp)
    
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
  }
}
