//
//  UIImage+FontWeatherIcon.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit
import CoreText

extension UIImage {
  
  /// Get a FontWeather image with the given icon name, text color, size and an optional background color.
  ///
  /// - parameter name: The preferred icon name.
  /// - parameter textColor: The text color.
  /// - parameter size: The image size.
  /// - parameter backgroundColor: The background color (optional).
  /// - returns: A string that will appear as icon with FontWeather
  static func fontWeather(icon type: FontWeatherIconType, textColor: UIColor, size: CGSize, backgroundColor: UIColor = .clear) -> UIImage {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    
    // Taken from FontWeather.io's Fixed Width Icon CSS
    let fontAspectRatio: CGFloat = 1.28571429
    
    let fontSize = min(size.width / fontAspectRatio, size.height)
    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWeather(size: fontSize), .foregroundColor: textColor, .backgroundColor: backgroundColor, .paragraphStyle: paragraph]
    
    let attributedString = NSAttributedString(string: type.iconCode, attributes: attributes)
    
    UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
    attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
