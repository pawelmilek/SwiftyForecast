import Foundation
import UIKit

enum FontWeatherIconType: String {
  case windBeaufort0 = "\u{f0b7}"
  case windBeaufort1 = "\u{f0b8}"
  case windBeaufort2 = "\u{f0b9}"
  case windBeaufort3 = "\u{f0ba}"
  case windBeaufort4 = "\u{f0bb}"
  case windBeaufort5 = "\u{f0bc}"
  case windBeaufort6 = "\u{f0bd}"
  case windBeaufort7 = "\u{f0be}"
  case windBeaufort8 = "\u{f0bf}"
  case windBeaufort9 = "\u{f0c0}"
  case windBeaufort10 = "\u{f0c1}"
  case windBeaufort11 = "\u{f0c2}"
  case windBeaufort12 = "\u{f0c3}"
  case daySunny = "\u{f00d}"
  case dayCloudy = "\u{f002}"
  case dayCloudyGusts = "\u{f000}"
  case dayCloudyWindy = "\u{f001}"
  case dayFog = "\u{f003}"
  case dayHail = "\u{f004}"
  case dayHaze = "\u{f0b6}"
  case dayLightning = "\u{f005}"
  case dayRain = "\u{f008}"
  case dayRainMix = "\u{f006}"
  case dayRainWind = "\u{f007}"
  case dayShowers = "\u{f009}"
  case daySleet = "\u{f0b2}"
  case daySleetStorm = "\u{f068}"
  case daySnow = "\u{f00a}"
  case daySnowThunderstorm = "\u{f06b}"
  case daySnowWind = "\u{f065}"
  case daySprinkle = "\u{f00b}"
  case dayStormShowers = "\u{f00e}"
  case daySunnyOvercast = "\u{f00c}"
  case dayThunderstorm = "\u{f010}"
  case dayWindy = "\u{f085}"
  case SolarEclipse = "\u{f06e}"
  case hot = "\u{f072}"
  case dayCloudyHigh = "\u{f07d}"
  case dayLightWind = "\u{f0c4}"
  case directionUp = "\u{f058}"
  case directionUpRight = "\u{f057}"
  case directionRight = "\u{f04d}"
  case directionDownRight = "\u{f088}"
  case directionDown = "\u{f044}"
  case directionDownLeft = "\u{f043}"
  case directionLeft = "\u{f048}"
  case directionUpLeft = "\u{f087}"
  case alien = "\u{f075}"
  case celsius = "\u{f03c}"
  case fahrenheit = "\u{f045}"
  case degrees = "\u{f042}"
  case thermometer = "\u{f055}"
  case thermometerExterior = "\u{f053}"
  case thermometerInternal = "\u{f054}"
  case cloudDown = "\u{f03d}"
  case cloudUp = "\u{f040}"
  case cloudRefresh = "\u{f03e}"
  case horizon = "\u{f047}"
  case horizonAlt = "\u{f046}"
  case sunrise = "\u{f051}"
  case sunset = "\u{f052}"
  case moonrise = "\u{f0c9}"
  case moonset = "\u{f0ca}"
  case refresh = "\u{f04c}"
  case refreshAlt = "\u{f04b}"
  case umbrella = "\u{f084}"
  case barometer = "\u{f079}"
  case humidity = "\u{f07a}"
  case na = "\u{f07b}"
  case train = "\u{f0cb}"
  case moonNew = "\u{f095}"
  case moonWaxingCrescent1 = "\u{f096}"
  case moonWaxingCrescent2 = "\u{f097}"
  case moonWaxingCrescent3 = "\u{f098}"
  case moonWaxingCrescent4 = "\u{f099}"
  case moonWaxingCrescent5 = "\u{f09a}"
  case moonWaxingCrescent6 = "\u{f09b}"
  case moonFirstQuarter = "\u{f09c}"
  case moonWaxingGibbous1 = "\u{f09d}"
  case moonWaxingGibbous2 = "\u{f09e}"
  case moonWaxingGibbous3 = "\u{f09f}"
  case moonWaxingGibbous4 = "\u{f0a0}"
  case moonWaxingGibbous5 = "\u{f0a1}"
  case moonWaxingGibbous6 = "\u{f0a2}"
  case moonFull = "\u{f0a3}"
  case moonWaningGibbous1 = "\u{f0a4}"
  case moonWaningGibbous2 = "\u{f0a5}"
  case moonWaningGibbous3 = "\u{f0a6}"
  case moonWaningGibbous4 = "\u{f0a7}"
  case moonWaningGibbous5 = "\u{f0a8}"
  case moonWaningGibbous6 = "\u{f0a9}"
  case moonThirdQuarter = "\u{f0aa}"
  case moonWaningCrescent1 = "\u{f0ab}"
  case moonWaningCrescent2 = "\u{f0ac}"
  case moonWaningCrescent3 = "\u{f0ad}"
  case moonWaningCrescent4 = "\u{f0ae}"
  case moonWaningCrescent5 = "\u{f0af}"
  case moonWaningCrescent6 = "\u{f0b0}"
  case moonAltNew = "\u{f0eb}"
  case moonAltWaxingCrescent1 = "\u{f0d0}"
  case moonAltWaxingCrescent2 = "\u{f0d1}"
  case moonAltWaxingCrescent3 = "\u{f0d2}"
  case moonAltWaxingCrescent4 = "\u{f0d3}"
  case moonAltWaxingCrescent5 = "\u{f0d4}"
  case moonAltWaxingCrescent6 = "\u{f0d5}"
  case moonAltFirstQuarter = "\u{f0d6}"
  case moonAltWaxingGibbous1 = "\u{f0d7}"
  case moonAltWaxingGibbous2 = "\u{f0d8}"
  case moonAltWaxingGibbous3 = "\u{f0d9}"
  case moonAltWaxingGibbous4 = "\u{f0da}"
  case moonAltWaxingGibbous5 = "\u{f0db}"
  case moonAltWaxingGibbous6 = "\u{f0dc}"
  case moonAltFull = "\u{f0dd}"
  case moonAltWaningGibbous1 = "\u{f0de}"
  case moonAltWaningGibbous2 = "\u{f0df}"
  case moonAltWaningGibbous3 = "\u{f0e0}"
  case moonAltWaningGibbous4 = "\u{f0e1}"
  case moonAltWaningGibbous5 = "\u{f0e2}"
  case moonAltWaningGibbous6 = "\u{f0e3}"
  case moonAltThirdQuarter = "\u{f0e4}"
  case moonAltWaningCrescent1 = "\u{f0e5}"
  case moonAltWaningCrescent2 = "\u{f0e6}"
  case moonAltWaningCrescent3 = "\u{f0e7}"
  case moonAltWaningCrescent4 = "\u{f0e8}"
  case moonAltWaningCrescent5 = "\u{f0e9}"
  case moonAltWaningCrescent6 = "\u{f0ea}"
  case cloud = "\u{f041}"
  case cloudy = "\u{f013}"
  case cloudyGusts = "\u{f011}"
  case cloudyWindy = "\u{f012}"
  case fog = "\u{f014}"
  case hail = "\u{f015}"
  case rain = "\u{f019}"
  case rainMix = "\u{f017}"
  case rainWind = "\u{f018}"
  case showers = "\u{f01a}"
  case sleet = "\u{f0b5}"
  case snow = "\u{f01b}"
  case sprinkle = "\u{f01c}"
  case stormShowers = "\u{f01d}"
  case thunderstorm = "\u{f01e}"
  case snowWind = "\u{f064}"
  case smog = "\u{f074}"
  case smoke = "\u{f062}"
  case lightning = "\u{f016}"
  case raindrops = "\u{f04e}"
  case raindrop = "\u{f078}"
  case dust = "\u{f063}"
  case snowflakeCold = "\u{f076}"
  case windy = "\u{f021}"
  case strongWind = "\u{f050}"
  case sandstorm = "\u{f082}"
  case earthquake = "\u{f0c6}"
  case fire = "\u{f0c7}"
  case flood = "\u{f07c}"
  case meteor = "\u{f071}"
  case tsunami = "\u{f0c5}"
  case volcano = "\u{f0c8}"
  case hurricane = "\u{f073}"
  case tornado = "\u{f056}"
  case smallCraftAdvisory = "\u{f0cc}"
  case galeWarning = "\u{f0cd}"
  case stormWarning = "\u{f0ce}"
  case hurricaneWarning = "\u{f0cf}"
  case windDirection = "\u{f0b1}"
  case nightClear = "\u{f02e}"
  case nightAltCloudy = "\u{f086}"
  case nightAltCloudyGusts = "\u{f022}"
  case nightAltCloudyWindy = "\u{f023}"
  case nightAltHail = "\u{f024}"
  case nightAltLightning = "\u{f025}"
  case nightAltRain = "\u{f028}"
  case nightAltRainMix = "\u{f026}"
  case nightAltRainWind = "\u{f027}"
  case nightAltShowers = "\u{f029}"
  case nightAltSleet = "\u{f0b4}"
  case nightAltSleetStorm = "\u{f06a}"
  case nightAltSnow = "\u{f02a}"
  case nightAltSnowThunderstorm = "\u{f06d}"
  case nightAltSnowWind = "\u{f067}"
  case nightAltSprinkle = "\u{f02b}"
  case nightAltStormShowers = "\u{f02c}"
  case nightAltThunderstorm = "\u{f02d}"
  case nightCloudy = "\u{f031}"
  case nightCloudyGusts = "\u{f02f}"
  case nightCloudyWindy = "\u{f030}"
  case nightFog = "\u{f04a}"
  case nightHail = "\u{f032}"
  case nightLightning = "\u{f033}"
  case nightPartlyCloudy = "\u{f083}"
  case nightRain = "\u{f036}"
  case nightRainMix = "\u{f034}"
  case nightRainWind = "\u{f035}"
  case nightShowers = "\u{f037}"
  case nightSleet = "\u{f0b3}"
  case nightSleetStorm = "\u{f069}"
  case nightSnow = "\u{f038}"
  case nightSnowThunderstorm = "\u{f06c}"
  case nightSnowWind = "\u{f066}"
  case nightSprinkle = "\u{f039}"
  case nightStormShowers = "\u{f03a}"
  case nightThunderstorm = "\u{f03b}"
  case lunarEclipse = "\u{f070}"
  case stars = "\u{f077}"
  case nightAltCloudyHigh = "\u{f07e}"
  case nightCloudyHigh = "\u{f080}"
  case nightAltPartlyCloudy = "\u{f081}"
  case time1 = "\u{f08a}"
  case time2 = "\u{f08b}"
  case time3 = "\u{f08c}"
  case time4 = "\u{f08d}"
  case time5 = "\u{f08e}"
  case time6 = "\u{f08f}"
  case time7 = "\u{f090}"
  case time8 = "\u{f091}"
  case time9 = "\u{f092}"
  case time10 = "\u{f093}"
  case time11 = "\u{f094}"
  case time12 = "\u{f089}"
}


// MARK: - String from the given CSS icon code. https://erikflowers.github.io/weather-icons/
extension FontWeatherIconType {
  
  static func make(from name: String) -> FontWeatherIconType? {
    guard let rawValue = fontWeatherIcons[name], let icon = FontWeatherIconType(rawValue: rawValue) else { return nil }
    return icon
  }
  
  
  func attributedString(font size: CGFloat) -> NSAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.fontWeather(size: size)]
    let attributedString = NSAttributedString(string: self.iconCode, attributes: attributes)
    
    return attributedString
  }

}


// MARK: - CSS icon code
extension FontWeatherIconType {
  
  var iconCode: String {
    return self.rawValue
  }
  
}


// MARK: - Private - An array of FontWeather icon codes.
extension FontWeatherIconType {
  
  private static var fontWeatherIcons: [String: String] {
    return [
      "wind-beaufort-0": "\u{f0b7}",
      "wind-beaufort-1": "\u{f0b8}",
      "wind-beaufort-2": "\u{f0b9}",
      "wind-beaufort-3": "\u{f0ba}",
      "wind-beaufort-4": "\u{f0bb}",
      "wind-beaufort-5": "\u{f0bc}",
      "wind-beaufort-6": "\u{f0bd}",
      "wind-beaufort-7": "\u{f0be}",
      "wind-beaufort-8": "\u{f0bf}",
      "wind-beaufort-9": "\u{f0c0}",
      "wind-beaufort-10": "\u{f0c1}",
      "wind-beaufort-11": "\u{f0c2}",
      "wind-beaufort-12": "\u{f0c3}",
      "day-sunny": "\u{f00d}",
      "day-cloudy": "\u{f002}",
      "day-cloudy-gusts": "\u{f000}",
      "day-cloudy-windy": "\u{f001}",
      "day-fog": "\u{f003}",
      "day-hail": "\u{f004}",
      "day-haze": "\u{f0b6}",
      "day-lightning": "\u{f005}",
      "day-rain": "\u{f008}",
      "day-rain-mix": "\u{f006}",
      "day-rain-wind": "\u{f007}",
      "day-showers": "\u{f009}",
      "day-sleet": "\u{f0b2}",
      "day-sleet-storm": "\u{f068}",
      "day-snow": "\u{f00a}",
      "day-snow-thunderstorm": "\u{f06b}",
      "day-snow-wind": "\u{f065}",
      "day-sprinkle": "\u{f00b}",
      "day-storm-showers": "\u{f00e}",
      "day-sunny-overcast": "\u{f00c}",
      "day-thunderstorm": "\u{f010}",
      "day-windy": "\u{f085}",
      "solar-eclipse": "\u{f06e}",
      "hot": "\u{f072}",
      "day-cloudy-high": "\u{f07d}",
      "day-light-wind": "\u{f0c4}",
      "direction-up": "\u{f058}",
      "direction-up-right": "\u{f057}",
      "direction-right": "\u{f04d}",
      "direction-down-right": "\u{f088}",
      "direction-down": "\u{f044}",
      "direction-down-left": "\u{f043}",
      "direction-left": "\u{f048}",
      "direction-up-left": "\u{f087}",
      "alien": "\u{f075}",
      "celsius": "\u{f03c}",
      "fahrenheit": "\u{f045}",
      "degrees": "\u{f042}",
      "thermometer": "\u{f055}",
      "thermometer-exterior": "\u{f053}",
      "thermometer-internal": "\u{f054}",
      "cloud-down": "\u{f03d}",
      "cloud-up": "\u{f040}",
      "cloud-refresh": "\u{f03e}",
      "horizon": "\u{f047}",
      "horizon-alt": "\u{f046}",
      "sunrise": "\u{f051}",
      "sunset": "\u{f052}",
      "moonrise": "\u{f0c9}",
      "moonset": "\u{f0ca}",
      "refresh": "\u{f04c}",
      "refresh-alt": "\u{f04b}",
      "umbrella": "\u{f084}",
      "barometer": "\u{f079}",
      "humidity": "\u{f07a}",
      "na": "\u{f07b}",
      "train": "\u{f0cb}",
      "moon-new": "\u{f095}",
      "moon-waxing-crescent-1": "\u{f096}",
      "moon-waxing-crescent-2": "\u{f097}",
      "moon-waxing-crescent-3": "\u{f098}",
      "moon-waxing-crescent-4": "\u{f099}",
      "moon-waxing-crescent-5": "\u{f09a}",
      "moon-waxing-crescent-6": "\u{f09b}",
      "moon-first-quarter": "\u{f09c}",
      "moon-waxing-gibbous-1": "\u{f09d}",
      "moon-waxing-gibbous-2": "\u{f09e}",
      "moon-waxing-gibbous-3": "\u{f09f}",
      "moon-waxing-gibbous-4": "\u{f0a0}",
      "moon-waxing-gibbous-5": "\u{f0a1}",
      "moon-waxing-gibbous-6": "\u{f0a2}",
      "moon-full": "\u{f0a3}",
      "moon-waning-gibbous-1": "\u{f0a4}",
      "moon-waning-gibbous-2": "\u{f0a5}",
      "moon-waning-gibbous-3": "\u{f0a6}",
      "moon-waning-gibbous-4": "\u{f0a7}",
      "moon-waning-gibbous-5": "\u{f0a8}",
      "moon-waning-gibbous-6": "\u{f0a9}",
      "moon-third-quarter": "\u{f0aa}",
      "moon-waning-crescent-1": "\u{f0ab}",
      "moon-waning-crescent-2": "\u{f0ac}",
      "moon-waning-crescent-3": "\u{f0ad}",
      "moon-waning-crescent-4": "\u{f0ae}",
      "moon-waning-crescent-5": "\u{f0af}",
      "moon-waning-crescent-6": "\u{f0b0}",
      "moon-alt-new": "\u{f0eb}",
      "moon-alt-waxing-crescent-1": "\u{f0d0}",
      "moon-alt-waxing-crescent-2": "\u{f0d1}",
      "moon-alt-waxing-crescent-3": "\u{f0d2}",
      "moon-alt-waxing-crescent-4": "\u{f0d3}",
      "moon-alt-waxing-crescent-5": "\u{f0d4}",
      "moon-alt-waxing-crescent-6": "\u{f0d5}",
      "moon-alt-first-quarter": "\u{f0d6}",
      "moon-alt-waxing-gibbous-1": "\u{f0d7}",
      "moon-alt-waxing-gibbous-2": "\u{f0d8}",
      "moon-alt-waxing-gibbous-3": "\u{f0d9}",
      "moon-alt-waxing-gibbous-4": "\u{f0da}",
      "moon-alt-waxing-gibbous-5": "\u{f0db}",
      "moon-alt-waxing-gibbous-6": "\u{f0dc}",
      "moon-alt-full": "\u{f0dd}",
      "moon-alt-waning-gibbous-1": "\u{f0de}",
      "moon-alt-waning-gibbous-2": "\u{f0df}",
      "moon-alt-waning-gibbous-3": "\u{f0e0}",
      "moon-alt-waning-gibbous-4": "\u{f0e1}",
      "moon-alt-waning-gibbous-5": "\u{f0e2}",
      "moon-alt-waning-gibbous-6": "\u{f0e3}",
      "moon-alt-third-quarter": "\u{f0e4}",
      "moon-alt-waning-crescent-1": "\u{f0e5}",
      "moon-alt-waning-crescent-2": "\u{f0e6}",
      "moon-alt-waning-crescent-3": "\u{f0e7}",
      "moon-alt-waning-crescent-4": "\u{f0e8}",
      "moon-alt-waning-crescent-5": "\u{f0e9}",
      "moon-alt-waning-crescent-6": "\u{f0ea}",
      "cloud": "\u{f041}",
      "cloudy": "\u{f013}",
      "cloudy-gusts": "\u{f011}",
      "cloudy-windy": "\u{f012}",
      "fog": "\u{f014}",
      "hail": "\u{f015}",
      "rain": "\u{f019}",
      "rain-mix": "\u{f017}",
      "rain-wind": "\u{f018}",
      "showers": "\u{f01a}",
      "sleet": "\u{f0b5}",
      "snow": "\u{f01b}",
      "sprinkle": "\u{f01c}",
      "storm-showers": "\u{f01d}",
      "thunderstorm": "\u{f01e}",
      "snow-wind": "\u{f064}",
      "smog": "\u{f074}",
      "smoke": "\u{f062}",
      "lightning": "\u{f016}",
      "raindrops": "\u{f04e}",
      "raindrop": "\u{f078}",
      "dust": "\u{f063}",
      "snowflake-cold": "\u{f076}",
      "windy": "\u{f021}",
      "strong-wind": "\u{f050}",
      "sandstorm": "\u{f082}",
      "earthquake": "\u{f0c6}",
      "fire": "\u{f0c7}",
      "flood": "\u{f07c}",
      "meteor": "\u{f071}",
      "tsunami": "\u{f0c5}",
      "volcano": "\u{f0c8}",
      "hurricane": "\u{f073}",
      "tornado": "\u{f056}",
      "small-craft-advisory": "\u{f0cc}",
      "gale-warning": "\u{f0cd}",
      "storm-warning": "\u{f0ce}",
      "hurricane-warning": "\u{f0cf}",
      "wind-direction": "\u{f0b1}",
      "night-clear": "\u{f02e}",
      "night-alt-cloudy": "\u{f086}",
      "night-alt-cloudy-gusts": "\u{f022}",
      "night-alt-cloudy-windy": "\u{f023}",
      "night-alt-hail": "\u{f024}",
      "night-alt-lightning": "\u{f025}",
      "night-alt-rain": "\u{f028}",
      "night-alt-rain-mix": "\u{f026}",
      "night-alt-rain-wind": "\u{f027}",
      "night-alt-showers": "\u{f029}",
      "night-alt-sleet": "\u{f0b4}",
      "night-alt-sleet-storm": "\u{f06a}",
      "night-alt-snow": "\u{f02a}",
      "night-alt-snow-thunderstorm": "\u{f06d}",
      "night-alt-snow-wind": "\u{f067}",
      "night-alt-sprinkle": "\u{f02b}",
      "night-alt-storm-showers": "\u{f02c}",
      "night-alt-thunderstorm": "\u{f02d}",
      "night-cloudy": "\u{f031}",
      "night-cloudy-gusts": "\u{f02f}",
      "night-cloudy-windy": "\u{f030}",
      "night-fog": "\u{f04a}",
      "night-hail": "\u{f032}",
      "night-lightning": "\u{f033}",
      "night-partly-cloudy": "\u{f083}",
      "night-rain": "\u{f036}",
      "night-rain-mix": "\u{f034}",
      "night-rain-wind": "\u{f035}",
      "night-showers": "\u{f037}",
      "night-sleet": "\u{f0b3}",
      "night-sleet-storm": "\u{f069}",
      "night-snow": "\u{f038}",
      "night-snow-thunderstorm": "\u{f06c}",
      "night-snow-wind": "\u{f066}",
      "night-sprinkle": "\u{f039}",
      "night-storm-showers": "\u{f03a}",
      "night-thunderstorm": "\u{f03b}",
      "lunar-eclipse": "\u{f070}",
      "stars": "\u{f077}",
      "night-alt-cloudy-high": "\u{f07e}",
      "night-cloudy-high": "\u{f080}",
      "night-alt-partly-cloudy": "\u{f081}",
      "time-1": "\u{f08a}",
      "time-2": "\u{f08b}",
      "time-3": "\u{f08c}",
      "time-4": "\u{f08d}",
      "time-5": "\u{f08e}",
      "time-6": "\u{f08f}",
      "time-7": "\u{f090}",
      "time-8": "\u{f091}",
      "time-9": "\u{f092}",
      "time-10": "\u{f093}",
      "time-11": "\u{f094}",
      "time-12": "\u{f089}"
    ]
  }
  
}

