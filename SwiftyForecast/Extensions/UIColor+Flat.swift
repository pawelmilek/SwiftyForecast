import UIKit

extension UIColor {
  
  static var primaryOne: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? redOrange : darkTurquoise
    }
  }
  
  static var primaryTwo: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? white : blueWhale
    }
  }
  
  static var primaryThree: UIColor {
    return UIColor { trait in
      return trait.userInterfaceStyle == .light ? brightGrey : heather
    }
  }
  
  static let redOrange = UIColor.colorRGB(component: (red: 253, green: 77, blue: 42))
  static let brightGrey = UIColor.colorRGB(component: (red: 82, green: 82, blue: 88))
  static let blueWhale = UIColor.colorRGB(component: (red: 22, green: 44, blue: 54))
  static let darkTurquoise = UIColor.colorRGB(component: (red: 0, green: 186, blue: 224))
  static let brightTurquoise = UIColor.colorRGB(component: (red: 0, green: 250, blue: 208))
  static let heather = UIColor.colorRGB(component: (red: 170, green: 180, blue: 190))
  
}

// MARK: - ColorRGB component
private extension UIColor {
  
  class func colorRGB(component: (red: CGFloat, green: CGFloat, blue: CGFloat)) -> UIColor {
    return UIColor(red: component.0/255, green: component.1/255, blue: component.2/255, alpha: 1)
  }
  
}
