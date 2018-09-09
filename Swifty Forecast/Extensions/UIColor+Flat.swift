//
//  UIColor+Flat.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit

extension UIColor {
  
  static var blackShade: UIColor {
    return UIColor.colorRGB(component: (r: 82, g: 82, b: 88))
  }
  
  static var gray94: UIColor {
    return UIColor.colorRGB(component: (r: 240, g: 240, b: 240))
  }
  
  static var ecstasy: UIColor {
    return UIColor.colorRGB(component: (r: 249, g: 105, b: 14))
  }
  
}


private extension UIColor {
  
  class func colorRGB(component: (r: CGFloat, g: CGFloat, b: CGFloat)) -> UIColor {
    return UIColor(red: component.0/255, green: component.1/255, blue: component.2/255, alpha: 1)
  }
  
}
