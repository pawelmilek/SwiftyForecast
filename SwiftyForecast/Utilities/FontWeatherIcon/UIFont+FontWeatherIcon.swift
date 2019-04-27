import UIKit

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
