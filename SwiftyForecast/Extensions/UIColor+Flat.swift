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
  
  static var lightOrange: UIColor {
    return UIColor.orange.withAlphaComponent(0.8)
  }
  
}

// MARK: - ColorRGB component
private extension UIColor {
  
  class func colorRGB(component: (r: CGFloat, g: CGFloat, b: CGFloat)) -> UIColor {
    return UIColor(red: component.0/255, green: component.1/255, blue: component.2/255, alpha: 1)
  }
  
}
