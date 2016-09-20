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


final class SwiftyWeather {
    var location: Location?
    var currentCondition: CurrentCondition?
    var hourlyConditions: [HourlyCondition]
    var dailyConditions: [DailyCondition]
    var forecastURL: String {
        get {
            var url: String = ""
            
            func appendFromForecastApi() {
                url.appendContentsOf(Constant.TheDarkSkyForecastApi.Url.baseForecast)
                url.appendContentsOf(Constant.TheDarkSkyForecastApi.appId)
            }

            func appendLocationsCoordinate() {
                guard let coordinate = self.location?.coordinate else { return }
                url.appendContentsOf(coordinate.description)
            }
            
            appendFromForecastApi()
            appendLocationsCoordinate()
            
            return url
        }
    }
    
    
    init() {
        self.hourlyConditions = [HourlyCondition]()
        self.dailyConditions = [DailyCondition]()
    }
    
    func appendHourlyCondition(hourly condition: HourlyCondition) -> Bool {
        self.hourlyConditions.append(condition)
        
        return true
    }
    
    func appendDailyCondition(daily condition: DailyCondition) -> Bool {
        self.dailyConditions.append(condition)
        
        return true
    }
    
    func clearConditions() {
        self.currentCondition = nil
        self.hourlyConditions.removeAll()
        self.dailyConditions.removeAll()
    }
    
    
    func changeConditionsMeasuringSystem() {
            
        func changeCurrentConditionMeasuringSystem() {
            guard var _ = self.currentCondition else { return }
            self.currentCondition!.convertAfterChangingUnitMeasuringSystem()
        }
        
        func changeHourlyConditionsMeasuringSystem() {
            let count: Int = self.hourlyConditions.count
            
            for index in (0..<count) {
                self.hourlyConditions[index].convertAfterChangingUnitMeasuringSystem()
            }
        }
        
        func changeDailyConditionsMeasuringSystem() {
            let count: Int = self.dailyConditions.count
            
            for index in (0..<count) {
                self.dailyConditions[index].convertAfterChangingUnitMeasuringSystem()
            }
        }

        changeCurrentConditionMeasuringSystem()
        changeHourlyConditionsMeasuringSystem()
        changeDailyConditionsMeasuringSystem()
    }
}


// MARK: Forecast Parser Delegate
extension SwiftyWeather: ForecastParserDelegate {
    
    func didParseWeatherData(parser: ForecastParser) {
        self.currentCondition = parser.currentCondition
        self.hourlyConditions = parser.twelveHoursCondidions
        self.dailyConditions = parser.sixDaysConditions
    }
}
