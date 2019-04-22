//
//  UIFont+FontWeatherIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit
import CoreText

extension UIFont {
  
  class func fontWeather(size: CGFloat) -> UIFont {
    let fontName = "Weather Icons"
    
    if UIFont.fontNames(forFamilyName: fontName).isEmpty {
      let name = "FontWeather"
      try? FontLoader.shared.loadFont(with: name)
    }

    return UIFont(name: fontName, size: size)!
  }
}
