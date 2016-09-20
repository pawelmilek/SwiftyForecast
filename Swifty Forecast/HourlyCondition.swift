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
import SwiftyJSON


struct HourlyCondition: Condition {
    var date: DateTime
    var temperature: Temperature
    var image: UIImage
    
    
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
            let icon = Icon(rawValue: "NA")!
            self.image = icon.image
        }
    }
    
    
    mutating func convertAfterChangingUnitMeasuringSystem() {
        self.temperature.convertWhenChangedMeasuringSystem(to: Setting.measuringSystem)
    }
}
