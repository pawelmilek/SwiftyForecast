//
//  Weather.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit


struct Weather {
  let city: City?
  let date: ForecastDate
  let icon: String
  let description: String
  let currentTemperatureFahrenheit: Double?
  let minTemperatureFahrenheit: Double?
  let maxTemperatureFahrenheit: Double?
  let moonPhase: MoonPhase?
  
  
  
  init(city: City?, timeStamp: Int, icon: String, description: String, currentTemp: Double? = nil, minTemp: Double? = nil, maxTemp: Double? = nil, moonPhaseLunation: Float? = nil) {
    self.city = city
    self.date = ForecastDate(timestamp: timeStamp)
    self.icon = icon
    self.currentTemperatureFahrenheit = currentTemp
    self.minTemperatureFahrenheit = minTemp
    self.maxTemperatureFahrenheit = maxTemp
    self.description = description
    self.moonPhase = MoonPhase(lunation: moonPhaseLunation ?? 0.0)
  }
}


// MARK: - isMetricMeasuringSystem
extension Weather {
  
  var currentTemperatureCelsius: Double? {
    guard let currentFahrenheit = self.currentTemperatureFahrenheit else { return nil }
    return (currentFahrenheit - 32) * Double(5.0 / 9.0)
  }
  
  var minTemperatureCelsius: Double? {
    guard let minFahrenheit = self.minTemperatureFahrenheit else { return nil }
    return (minFahrenheit - 32) * Double(5.0 / 9.0)
  }
  
  var maxTemperatureCelsius: Double? {
    guard let maxFahrenheit = self.maxTemperatureFahrenheit else { return nil }
    return (maxFahrenheit - 32) * Double(5.0 / 9.0)
  }
  
}


// MARK: - Temperature Icon
extension Weather {
  
  var thermometerIcon: NSAttributedString? {
    return IconType.thermometer.fontIcon
  }
  
}


extension Weather {
  
  var cityName: String {
    return self.city?.name ?? ""
  }
  
  var cityAndCountry: String {
    return self.city?.fullName ?? ""
  }
  
}

