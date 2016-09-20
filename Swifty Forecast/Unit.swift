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
/*--------------------------------------------------------
//  Temperature Unit:
//  Metric: Celsius
//  Imperial: Fahrenheit
//
//  Wind speed Unit:
//  Metric: meter/sec
//  Imperial: miles/hour
--------------------------------------------------------*/
import Foundation


struct Unit: Equatable {
    private var quantity: Quantity
    private(set) var measuringSystem: MeasuringSystem
    var name: String {
        get {
            let quantityAndMeasuringSystem = (self.quantity, self.measuringSystem)
            
            switch quantityAndMeasuringSystem {
            case (Quantity.Temperature, MeasuringSystem.Metric):
                return UnitSymbols.Celsius.description
                
            case (Quantity.Temperature, MeasuringSystem.Imperial):
                return UnitSymbols.Fahrenheit.description
                
            case (Quantity.Speed, MeasuringSystem.Metric):
                return UnitSymbols.MeterPerSec.description
                
            case (Quantity.Speed, MeasuringSystem.Imperial):
                return UnitSymbols.MilesPerHour.description
                
            case (Quantity.Direction, _):
                return UnitSymbols.Degree.description
                
            case (Quantity.Pressure, _):
                return UnitSymbols.Hectopascal.description
                
            case (Quantity.Humidity, _), (Quantity.Cloudiness, _):
                return UnitSymbols.Percent.description
                
            case (Quantity.Volume, _):
                return UnitSymbols.Millimeter.description
                
            default:
                return UnitSymbols.Default.description
            }
        }
    }
    var symbol: String {
        get {
            switch self.name {
            case UnitSymbols.Celsius.description:
                return UnitSymbols.Celsius.rawValue
                
            case UnitSymbols.Fahrenheit.description:
                return UnitSymbols.Fahrenheit.rawValue
                
            case UnitSymbols.MeterPerSec.description:
                return UnitSymbols.MeterPerSec.rawValue
                
            case UnitSymbols.MilesPerHour.description:
                return UnitSymbols.MilesPerHour.rawValue
                
            case UnitSymbols.Degree.description:
                return UnitSymbols.Degree.rawValue
                
            case UnitSymbols.Hectopascal.description:
                return UnitSymbols.Hectopascal.rawValue
                
            case UnitSymbols.Percent.description:
                return UnitSymbols.Percent.rawValue
                
            case UnitSymbols.Millimeter.description:
                return UnitSymbols.Millimeter.rawValue
                
            default:
                return UnitSymbols.Default.rawValue
            }
        }
    }

    
    
    init(quantity: Quantity, measuringSystem: MeasuringSystem = Setting.measuringSystem) {
        self.measuringSystem = measuringSystem
        self.quantity = quantity
    }

    
    mutating func changeMeasuringSystem(to measuringSystem: MeasuringSystem) {
        self.measuringSystem = measuringSystem
    }
}


func ==(lhs: Unit, rhs: Unit) -> Bool {
    func isEqual() -> Bool {
        return lhs.measuringSystem.description == rhs.measuringSystem.description
            && lhs.quantity == rhs.quantity
            && lhs.name == rhs.name
            && lhs.symbol == rhs.symbol
    }
    
    
    if isEqual() {
        return true
    }
    return false
}
