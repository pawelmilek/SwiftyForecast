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
import SwiftyJSON


struct CurrentCondition: Condition, Equatable {
    var date: DateTime
    var temperature: Temperature
    var image: UIImage
    
    var summaryDescription: String
    var sunAndMoonState: Astronomy
    var atmosphere: Atmosphere
    var wind: Wind


   
    init(condition: [String : JSON]) {
        let date = condition[JSONDataBlock.DataPoint.time]!.numberValue.integerValue
        self.date = DateTime(timeStamp: date)
        
        let tmpTemperature = condition[JSONDataBlock.DataPoint.temperature]!.number!
        let temperatures: [String : Int?] = ["temperature" : Int(tmpTemperature.doubleValue)]
        self.temperature = Temperature(temperature: temperatures)
        
        let iconName = condition[JSONDataBlock.DataPoint.icon]!.stringValue
        if let icon = Icon(rawValue: iconName) {
            self.image = icon.image
            
        } else {
            let icon = Icon(rawValue: "NA")
            self.image = icon!.image
        }
        
        
        
        self.summaryDescription = condition[JSONDataBlock.DataPoint.summary]!.stringValue
        
        let lunationNumber = condition[JSONDataBlock.DataPoint.moonPhase]!.numberValue.doubleValue
        let sunrise = condition[JSONDataBlock.DataPoint.sunriseTime]!.numberValue.integerValue
        let sunset = condition[JSONDataBlock.DataPoint.sunsetTime]!.numberValue.integerValue
        self.sunAndMoonState = Astronomy(lunationNumber: lunationNumber, sunState: (sunrise, sunset))
    
        let pressure = Int(condition[JSONDataBlock.DataPoint.pressure]!.numberValue.doubleValue.roundToPlaces(0))
        let humidity = Int(condition[JSONDataBlock.DataPoint.humidity]!.numberValue.doubleValue.roundToPlaces(0))
        let cloud = Int(condition[JSONDataBlock.DataPoint.cloudCover]!.numberValue.doubleValue.roundToPlaces(0))
        self.atmosphere = Atmosphere(pressureAndHumidity: (pressure, humidity), cloudiness: cloud)
    
        let speed = Int(condition[JSONDataBlock.DataPoint.windSpeed]!.numberValue.doubleValue.roundToPlaces(0))
        let degree = Int(condition[JSONDataBlock.DataPoint.windBearing]!.numberValue.doubleValue.roundToPlaces(0))
        self.wind = Wind(speed: speed, degree: degree)
    }
    
    mutating func convertAfterChangingUnitMeasuringSystem() {
        self.temperature.convertWhenChangedMeasuringSystem(to: Setting.measuringSystem)
        self.wind.convertWhenChangedMeasuringSystem(to: Setting.measuringSystem)
    }
}

extension CurrentCondition {
    
    func temperatureCurrently() -> Int? {
        return self.temperature.currentlyTemperature()
    }
}


// MARK: Protocol Equatable
func ==(lhs: CurrentCondition, rhs: CurrentCondition) -> Bool {
    if lhs.sunAndMoonState == rhs.sunAndMoonState
        && lhs.date == rhs.date
        && lhs.atmosphere == rhs.atmosphere
        && lhs.temperature == rhs.temperature
        && lhs.wind == rhs.wind
        && lhs.summaryDescription == rhs.summaryDescription {
            return true
    }
    
    return false
}

