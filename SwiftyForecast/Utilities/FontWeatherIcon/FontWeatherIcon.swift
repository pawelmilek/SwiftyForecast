import Foundation
import UIKit

protocol FontWeatherIcon {
  associatedtype T: FontWeatherIcon
  var attributedIcon: NSAttributedString { get }
  
  static func make(icon: String, font size: CGFloat) -> T?
}
