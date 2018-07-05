//
//  MoonPhaseFontIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import WeatherIconsKit

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
extension MoonPhaseFontIcon: WeatherFontIcon {
  
  static func make(icon: String, font size: CGFloat) -> MoonPhaseFontIcon? {
    guard let condition = MoonPhaseType(rawValue: icon) else { return nil }
    
    var attributedFont: NSAttributedString?
    
    switch condition {
    case .newMoon:
      attributedFont = WIKFontIcon.wiMoonNewIcon(withSize: size).attributedString()
      
    case .waxingCrescent:
      attributedFont = WIKFontIcon.wiMoonWaxingCresent1Icon(withSize: size).attributedString()
      
    case .firstQuarterMoon:
      attributedFont = WIKFontIcon.wiMoonFirstQuarterIcon(withSize: size).attributedString()
      
    case .waxingGibbous:
      attributedFont = WIKFontIcon.wiMoonWaxingGibbous1Icon(withSize: size).attributedString()
      
    case .fullMoon:
      attributedFont = WIKFontIcon.wiMoonFullIcon(withSize: size).attributedString()
      
    case .waningGibbous:
      attributedFont = WIKFontIcon.wiMoonWaningGibbous1Icon(withSize: size).attributedString()
      
    case .lastQuarterMoon:
      attributedFont = WIKFontIcon.wiMoon3rdQuarterIcon(withSize: size).attributedString()
      
    case .waningCrescent:
      attributedFont = WIKFontIcon.wiMoonWaningCrescent1Icon(withSize: size).attributedString()
    }
    
    return MoonPhaseFontIcon(attributedIcon: attributedFont)
  }
  
}
