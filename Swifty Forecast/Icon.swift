/**
 * Created by Pawel Milek on 27/07/16.
 * Copyright © 2016 imac. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit


enum Icon: String {
    // Condition
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    case Fog = "fog"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Hail = "hail"
    case Thunderstorm = "thunderstorm"
    case Tornado = "tornado"
    
    // Wind direction
    case NorthDirection = "north"
    case NorthEastDirection = "north - East"
    case EastDirection = "east"
    case SouthEastDirection = "south - East"
    case SouthDirection = "south"
    case SouthWestDirection = "south - West"
    case WestDirection = "west"
    case NorthWestDirection = "north - west"
    
    // Moon phase
    case NewMoon = "New moon"
    case WaxingCrescent = "Waxing crescent"
    case FirstQuarterMoon = "First quarter moon"
    case WaxingGibbous = "Waxing gibbous"
    case FullMoon = "Full moon"
    case WaningGibbous = "Waning gibbous"
    case LastQuarterMoon = "Last quarter moon"
    case WaningCrescent = "Waning crescent"
    
    case NA = "NA"
    
    // Temperature
    case ThermometerCold = "thermometer cold"
    case ThermometerHot = "thermometer hot"
    case ThermometerLowWarm = "thermometer low warm"
    case ThermometerVeryCold = "thermometer very cold"
    case ThermometerVeryHot = "thermometer very hot"
    case ThermometerWarm = "thermometer warm"
    
    // Sunstate
    case Sunrise = "sunrise"
    case Sunset = "sunset"
    
    var image: UIImage {
        get {
            switch self {
            // MARK: Condition image
            case .ClearDay:
                return UIImage(named: "sun.png")!
                
            case .ClearNight:
                return UIImage(named: "moon.png")!
                
            case .Cloudy:
                return UIImage(named: "cloud.png")!
                
            case .PartlyCloudyDay:
                return UIImage(named: "day_cloud.png")!
                
            case .PartlyCloudyNight:
                return UIImage(named: "night_cloud.png")!
                
            case .Fog:
                return UIImage(named: "fog.png")!
                
            case .Rain:
                return UIImage(named: "drizzle.png")!
                
            case .Snow:
                return UIImage(named: "snow.png")!
                
            case .Sleet:
                return UIImage(named: "hail.png")!
                
            case .Wind:
                return UIImage(named: "wind.png")!
                
            case .Hail:
                return UIImage(named: "hail.png")!
                
            case .Thunderstorm:
                return UIImage(named: "lightning.png")!
                
            case .Tornado:
                return UIImage(named: "tornado.png")!


            // MARK: Wind image
            case .NorthDirection:
                return UIImage(named: "compass_N.png")!
                
            case .NorthEastDirection:
                return UIImage(named: "compass_NE.png")!
                
            case .EastDirection:
                return UIImage(named: "compass_E.png")!
                
            case .SouthEastDirection:
                return UIImage(named: "compass_SE.png")!
                
            case .SouthDirection:
                return UIImage(named: "compass_S.png")!
                
            case .SouthWestDirection:
                return UIImage(named: "compass_SW.png")!
                
            case .WestDirection:
                return UIImage(named: "compass_W.png")!
                
            case .NorthWestDirection:
                return UIImage(named: "compass_NW.png")!
                
                
            // MARK: Moon image
            case .NewMoon:
                return UIImage(named: "new_moon.png")!
                
            case .WaxingCrescent:
                return UIImage(named: "moon_waxing_crescent.png")!
                
            case .FirstQuarterMoon:
                return UIImage(named: "moon_first_quarter.png")!
                
            case .WaxingGibbous:
                return UIImage(named: "moon_waxing_gibbous.png")!
                
            case .FullMoon:
                return UIImage(named: "full_moon.png")!
                
            case .WaningGibbous:
                return UIImage(named: "moon_waning_gibbous.png")!
                
            case .LastQuarterMoon:
                return UIImage(named: "moon_last_quarter.png")!
                
            case .WaningCrescent:
                return UIImage(named: "moon_waning_crescent.png")!
                
            
            // MARK: Temperature
            case .ThermometerCold:
                return UIImage(named: "thermometer_cold.png")!
                
            case .ThermometerHot:
                return UIImage(named: "thermometer_hot.png")!
                
            case .ThermometerLowWarm:
                return UIImage(named: "thermometer_low_warm.png")!
                
            case .ThermometerVeryCold:
                return UIImage(named: "thermometer_very_cold.png")!
                
            case .ThermometerVeryHot:
                return UIImage(named: "thermometer_very_hot.png")!
                
            case .ThermometerWarm:
                return UIImage(named: "thermometer_warm.png")!
                
            // MARK: Sun State
            case .Sunrise:
                return UIImage(named: "sunrise.png")!
                
            case .Sunset:
                return UIImage(named: "sunset.png")!
                
            // MARK: NA image
            case .NA:
                return UIImage(named: "na.png")!
                
            }
        }
    }
    
}
