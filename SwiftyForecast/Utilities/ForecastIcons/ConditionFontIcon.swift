import Foundation
import UIKit

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
extension ConditionFontIcon: FontWeatherIcon {

  static func make(icon: String, font size: CGFloat) -> ConditionFontIcon? {
    guard let condition = ConditionType(rawValue: icon) else { return nil }
    
    var attributedFont: NSAttributedString?
    
    switch condition {
    case .clearDay:
      attributedFont = FontWeatherIconType.daySunny.attributedString(font: size)
      
    case .clearNight:
      attributedFont = FontWeatherIconType.nightClear.attributedString(font: size)
      
    case .cloudy:
      attributedFont = FontWeatherIconType.dayCloudy.attributedString(font: size)
      
    case .partlyCloudyDay:
      attributedFont = FontWeatherIconType.dayCloudy.attributedString(font: size)
      
    case .partlyCloudyNight:
      attributedFont = FontWeatherIconType.nightCloudy.attributedString(font: size)
      
    case .fog:
      attributedFont = FontWeatherIconType.fog.attributedString(font: size)
      
    case .rain:
      attributedFont = FontWeatherIconType.rain.attributedString(font: size)
      
    case .snow:
      attributedFont = FontWeatherIconType.snow.attributedString(font: size)
      
    case .sleet:
      attributedFont = FontWeatherIconType.sleet.attributedString(font: size)
      
    case .wind:
      attributedFont = FontWeatherIconType.windy.attributedString(font: size)
      
    case .hail:
      attributedFont = FontWeatherIconType.hail.attributedString(font: size)
      
    case .thunderstorm:
      attributedFont = FontWeatherIconType.thunderstorm.attributedString(font: size)
      
    case .tornado:
      attributedFont = FontWeatherIconType.tornado.attributedString(font: size)
    }
    
    return ConditionFontIcon(attributedIcon: attributedFont)
  }
  
}
