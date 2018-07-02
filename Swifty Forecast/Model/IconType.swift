//
//  IconType.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import WeatherIconsKit


enum IconType: String {
  // Condition
  case clearDay = "clear-day"
  case clearNight = "clear-night"
  case cloudy = "cloudy"
  case partlyCloudyDay = "partly-cloudy-day"
  case partlyCloudyNight = "partly-cloudy-night"
  case fog = "fog"
  case rain = "rain"
  case snow = "snow"
  case sleet = "sleet"
  case wind = "wind"
  case hail = "hail"
  case thunderstorm = "thunderstorm"
  case tornado = "tornado"
  
  // Moon phase
  case newMoon = "New moon"
  case waxingCrescent = "Waxing crescent"
  case firstQuarterMoon = "First quarter moon"
  case waxingGibbous = "Waxing gibbous"
  case fullMoon = "Full moon"
  case waningGibbous = "Waning gibbous"
  case lastQuarterMoon = "Last quarter moon"
  case waningCrescent = "Waning crescent"
  
  // Thermometer
  case thermometer = "thermometer"
}


// MARK: - WIKFontIcon
extension IconType {
  
  var fontIcon: NSAttributedString {
    let conditionFontSize: CGFloat = 39
    let moonPhaseFontSize: CGFloat = 34
    let thermometerFontSize: CGFloat = 50
    
    switch self {
    case .clearDay:
      return WIKFontIcon.wiDaySunnyIcon(withSize: conditionFontSize).attributedString()
      
    case .clearNight:
      return WIKFontIcon.wiNightClear(withSize: conditionFontSize).attributedString()
      
    case .cloudy:
      return WIKFontIcon.wiDayCloudyIcon(withSize: conditionFontSize).attributedString()
      
    case .partlyCloudyDay:
      return WIKFontIcon.wiDayCloudyIcon(withSize: conditionFontSize).attributedString()
      
    case .partlyCloudyNight:
      return WIKFontIcon.wiNightCloudyIcon(withSize: conditionFontSize).attributedString()
      
    case .fog:
      return WIKFontIcon.wiFogIcon(withSize: conditionFontSize).attributedString()
      
    case .rain:
      return WIKFontIcon.wiRain(withSize: conditionFontSize).attributedString()
      
    case .snow:
      return WIKFontIcon.wiSnow(withSize: conditionFontSize).attributedString()
      
    case .sleet:
      return WIKFontIcon.wiSleetIcon(withSize: conditionFontSize).attributedString()
      
    case .wind:
      return WIKFontIcon.wiWindyIcon(withSize: conditionFontSize).attributedString()
      
    case .hail:
      return WIKFontIcon.wiHailIcon(withSize: conditionFontSize).attributedString()
      
    case .thunderstorm:
      return WIKFontIcon.wiThunderstormIcon(withSize: conditionFontSize).attributedString()
      
    case .tornado:
      return WIKFontIcon.wiTornadoIcon(withSize: conditionFontSize).attributedString()
      
    // MARK: - Moon phase
    case .newMoon:
      return WIKFontIcon.wiMoonNewIcon(withSize: moonPhaseFontSize).attributedString()
      
    case .waxingCrescent:
      return WIKFontIcon.wiMoonWaxingCresent1Icon(withSize: moonPhaseFontSize).attributedString()
      
    case .firstQuarterMoon:
      return WIKFontIcon.wiMoonFirstQuarterIcon(withSize: moonPhaseFontSize).attributedString()
      
    case .waxingGibbous:
      return WIKFontIcon.wiMoonWaxingGibbous1Icon(withSize: moonPhaseFontSize).attributedString()
      
    case .fullMoon:
      return WIKFontIcon.wiMoonFullIcon(withSize: moonPhaseFontSize).attributedString()
      
    case .waningGibbous:
      return WIKFontIcon.wiMoonWaningGibbous1Icon(withSize: moonPhaseFontSize).attributedString()
      
    case .lastQuarterMoon:
      return WIKFontIcon.wiMoon3rdQuarterIcon(withSize: moonPhaseFontSize).attributedString()
      
    case .waningCrescent:
      return WIKFontIcon.wiMoonWaningCrescent1Icon(withSize: moonPhaseFontSize).attributedString()
      
    case .thermometer:
      return WIKFontIcon.wiThermometerIcon(withSize: thermometerFontSize).attributedString()
    }
  }
}
