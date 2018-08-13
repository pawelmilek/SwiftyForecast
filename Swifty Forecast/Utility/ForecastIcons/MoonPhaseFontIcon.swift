//
//  MoonPhaseFontIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

struct MoonPhaseFontIcon {
  enum MoonPhaseType: String {
    case newMoon = "New moon"
    case waxingCrescent = "Waxing crescent"
    case firstQuarterMoon = "First quarter moon"
    case waxingGibbous = "Waxing gibbous"
    case fullMoon = "Full moon"
    case waningGibbous = "Waning gibbous"
    case lastQuarterMoon = "Last quarter moon"
    case waningCrescent = "Waning crescent"
  }
  
  typealias T = MoonPhaseFontIcon
  var attributedIcon: NSAttributedString
  
  
  init?(attributedIcon: NSAttributedString?) {
    guard let attributedIcon = attributedIcon else { return nil }
    self.attributedIcon = attributedIcon
  }
}


// MARK: - WeatherFontIcon protocol
extension MoonPhaseFontIcon: FontWeatherIcon {
  
  static func make(icon: String, font size: CGFloat) -> MoonPhaseFontIcon? {
    guard let condition = MoonPhaseType(rawValue: icon) else { return nil }
    
    var attributedFont: NSAttributedString?
    
    switch condition {
    case .newMoon:
      attributedFont = FontWeatherIconType.moonNew.attributedString(font: size)
      
    case .waxingCrescent:
      attributedFont = FontWeatherIconType.moonWaxingCrescent1.attributedString(font: size)
      
    case .firstQuarterMoon:
      attributedFont = FontWeatherIconType.moonFirstQuarter.attributedString(font: size)
      
    case .waxingGibbous:
      attributedFont = FontWeatherIconType.moonWaxingGibbous1.attributedString(font: size)
      
    case .fullMoon:
      attributedFont = FontWeatherIconType.moonFull.attributedString(font: size)
      
    case .waningGibbous:
      attributedFont = FontWeatherIconType.moonWaningGibbous1.attributedString(font: size)
      
    case .lastQuarterMoon:
      attributedFont = FontWeatherIconType.moonThirdQuarter.attributedString(font: size)
      
    case .waningCrescent:
      attributedFont = FontWeatherIconType.moonWaningCrescent1.attributedString(font: size)
    }
    
    return MoonPhaseFontIcon(attributedIcon: attributedFont)
  }
  
}
