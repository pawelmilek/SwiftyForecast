//
//  CurrentForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct CurrentForecast: Forecast {
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
  let uvIndex: Int
  let visibility: Double
  let ozone: Double
}


// MARK: - Temperature in Celsius
extension CurrentForecast {
  
  private var temperatureInCelsius: Double {
    return (temperature - 32) * Double(5.0 / 9.0)
  }
  
  var temperatureFormatted: String {
    if MeasuringSystem.isMetric {
      return temperatureInCelsius.roundedToNearestAsString + "\u{00B0}"
    } else {
      return temperature.roundedToNearestAsString + "\u{00B0}"
    }
  }
  
}


// MARK: - Decodable protocol
extension CurrentForecast: Decodable {
  
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
    case uvIndex
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
    self.uvIndex = try container.decode(Int.self, forKey: .uvIndex)
    self.visibility = try container.decode(Double.self, forKey: .visibility)
    self.ozone = try container.decode(Double.self, forKey: .ozone)
  }
}
