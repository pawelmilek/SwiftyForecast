//
//  DailyData.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct DailyData: Forecast {
  let date: ForecastDate
  let summary: String
  let icon: String
  
  let sunriseTime: ForecastDate
  let sunsetTime: ForecastDate
  let moonPhase: MoonPhase
  let precipIntensity: Double
  let precipProbability: Double
  
  let temperature: Double = 0
  let apparentTemperature: Double = 0
  
  let precipType: String?
  let temperatureMin: Double
  let temperatureMinTime: ForecastDate
  let temperatureMax: Double
  let temperatureMaxTime: ForecastDate
  
  let dewPoint: Double
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
  let windGust: Double
  
  let windBearing: Double
  let cloudCover: Double
  let uvIndex: Int
  let visibility: Double
  let ozone: Double
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
      return temperatureInCelsiusMin.roundedToNearestAsString + "\u{00B0}"
    } else {
      return temperatureMin.roundedToNearestAsString + "\u{00B0}"
    }
  }
  
  var temperatureMaxFormatted: String {
    if MeasuringSystem.isMetric {
      return temperatureInCelsiusMax.roundedToNearestAsString + "\u{00B0}"
    } else {
      return temperatureMax.roundedToNearestAsString + "\u{00B0}"
    }
  }
  
}


// MARK: - Decodable protocol
extension DailyData: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case sunriseTime
    case sunsetTime
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
    
    self.date = try ForecastDate(from: decoder)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    
    let sunriseTimestamp = try container.decode(Int.self, forKey: .sunriseTime)
    let sunsetTimestamp = try container.decode(Int.self, forKey: .sunsetTime)
    self.sunriseTime = ForecastDate(timestamp: sunriseTimestamp)
    self.sunsetTime = ForecastDate(timestamp: sunsetTimestamp)
    
    self.moonPhase = try MoonPhase(from: decoder)
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
