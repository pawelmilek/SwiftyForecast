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


final class ForecastParser {
    private var dataFromNetworking: JSON?
    var delegate: ForecastParserDelegate?
    //var location: Location?
    private(set) var currentCondition: CurrentCondition?
    private(set) var twelveHoursCondidions: [HourlyCondition] = [HourlyCondition]()
    private(set) var sixDaysConditions: [DailyCondition] = [DailyCondition]()
    
    
    //    private func parseLocation() {
    //        guard let data = self.dataFromNetworking else { fatalError("Couldn't featch location") }
    //
    //        let city = data["city"]["country"].stringValue
    //        let country = data["city"]["name"].stringValue
    //        self.location = Location(city: city, country: country)
    //    }
    
    private func parseConditionForCurrentExtendedDay() {
        guard let currently = self.dataFromNetworking?[JSONDataBlock.currently].dictionary else {
            print("Couldn't fetch currently data")
            return
        }
        guard let currentlyForecast = self.dataFromNetworking?[JSONDataBlock.daily][JSONDataBlock.data][0].dictionary else { print("Couldn't fetch daily forecast")
            return
        }
        
        let moonPhase: String = "moonPhase"
        let sunriseTime: String = "sunriseTime"
        let sunsetTime: String = "sunsetTime"
        
        let lunationNumber = currentlyForecast[moonPhase]
        let sunrise = currentlyForecast[sunriseTime]
        let sunset = currentlyForecast[sunsetTime]
        var currentExtended: [String : JSON] = currently
        
        currentExtended[moonPhase] = lunationNumber
        currentExtended[sunriseTime] = sunrise
        currentExtended[sunsetTime] = sunset
        
        self.currentCondition = CurrentCondition(condition: currentExtended)
    }
    
    
    private func parseConditionsForNextTwelveHours() {
        func clearTwelveHoursCondidions() {
            if self.twelveHoursCondidions.count > 0 {
                self.twelveHoursCondidions.removeAll()
            }
        }
        
        guard let hourlyDataDictionary = self.dataFromNetworking?[JSONDataBlock.hourly].dictionary else {
            print("Couldn't fetch hourly data")
            return
        }
        guard let hourlyForecast = hourlyDataDictionary[JSONDataBlock.data]?.array else {
            print("Undefined data in JSON \(self.dataFromNetworking)")
            return
        }
        
        
        clearTwelveHoursCondidions()
        let numberOfHours: Int = 12
        
        for index in 0..<numberOfHours {
            guard let nextHour = hourlyForecast[index].dictionary else { continue }
            let condition = HourlyCondition(condition: nextHour)
            self.twelveHoursCondidions.append(condition)
            
        }
    }

    
    private func parseConditionsForSixDays() {
        guard let dailyDataDictionary = self.dataFromNetworking?["daily"].dictionary else {
            print("Couldn't fetch daily forecast")
            return
        }
        guard let forecastConditions = dailyDataDictionary["data"]?.array else {
            print("Undefined data in JSON \(self.dataFromNetworking)")
            return
        }
        
        if self.sixDaysConditions.count > 0 {
            self.sixDaysConditions.removeAll()
        }
        
        var index: Int = 2
        repeat {
            if let con = forecastConditions[index].dictionary {
                let condition = DailyCondition(condition: con)
                
                self.sixDaysConditions.append(condition)
            }
            
            index += 1
        } while index < forecastConditions.count
    }
}


// MARK: RestApiRequest Delegate
extension ForecastParser: RestApiRequestDelegate {
    
    func didFetchDataFrom(rest: RestApiRequest) {
        if let data = rest.completionData {
            self.dataFromNetworking = JSON(data: data)
            
            self.parseConditionForCurrentExtendedDay()
            self.parseConditionsForNextTwelveHours()
            self.parseConditionsForSixDays()
            

            self.delegate?.didParseWeatherData(self)
        }
    }
}
