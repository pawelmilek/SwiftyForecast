//
//  ConditionFontIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import WeatherIconsKit


struct ConditionFontIcon {
  enum ConditionType: String {
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
  }
  
  typealias T = ConditionFontIcon
  var attributedIcon: NSAttributedString
  
  
  init?(attributedIcon: NSAttributedString?) {
    guard let attributedIcon = attributedIcon else { return nil }
    self.attributedIcon = attributedIcon
  }
}


// MARK: - WeatherFontIcon protocol
extension ConditionFontIcon: WeatherFontIcon {

  static func make(icon: String, font size: CGFloat) -> ConditionFontIcon? {
    guard let condition = ConditionType(rawValue: icon) else { return nil }
    
    var attributedFont: NSAttributedString?
    
    switch condition {
    case .clearDay:
      attributedFont = WIKFontIcon.wiDaySunnyIcon(withSize: size).attributedString()
      
    case .clearNight:
      attributedFont = WIKFontIcon.wiNightClear(withSize: size).attributedString()
      
    case .cloudy:
      attributedFont = WIKFontIcon.wiDayCloudyIcon(withSize: size).attributedString()
      
    case .partlyCloudyDay:
      attributedFont = WIKFontIcon.wiDayCloudyIcon(withSize: size).attributedString()
      
    case .partlyCloudyNight:
      attributedFont = WIKFontIcon.wiNightCloudyIcon(withSize: size).attributedString()
      
    case .fog:
      attributedFont = WIKFontIcon.wiFogIcon(withSize: size).attributedString()
      
    case .rain:
      attributedFont = WIKFontIcon.wiRain(withSize: size).attributedString()
      
    case .snow:
      attributedFont = WIKFontIcon.wiSnow(withSize: size).attributedString()
      
    case .sleet:
      attributedFont = WIKFontIcon.wiSleetIcon(withSize: size).attributedString()
      
    case .wind:
      attributedFont = WIKFontIcon.wiWindyIcon(withSize: size).attributedString()
      
    case .hail:
      attributedFont = WIKFontIcon.wiHailIcon(withSize: size).attributedString()
      
    case .thunderstorm:
      attributedFont = WIKFontIcon.wiThunderstormIcon(withSize: size).attributedString()
      
    case .tornado:
      attributedFont = WIKFontIcon.wiTornadoIcon(withSize: size).attributedString()
    }
    
    
    return ConditionFontIcon(attributedIcon: attributedFont)
  }
  
}
