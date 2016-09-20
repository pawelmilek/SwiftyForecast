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


struct Wind: Equatable {
    private var degree: (value: Int, unit: Unit)
    private var speed: (value: Int, unit: Unit)
    var compassIcon: UIImage {
        get {
            func compassN() -> UIImage {
                return UIImage(named: "compass_N.png")!
            }
            
            func compassNE() -> UIImage {
                return UIImage(named: "compass_NE.png")!
            }
            
            func compassE() -> UIImage {
                return UIImage(named: "compass_E.png")!
            }
            
            func compassSE() -> UIImage {
                return UIImage(named: "compass_SE.png")!
            }
            
            func compassS() -> UIImage {
                return UIImage(named: "compass_S.png")!
            }
            
            func compassSW() -> UIImage {
                return UIImage(named: "compass_SW.png")!
            }
            
            func compassW() -> UIImage {
                return UIImage(named: "compass_W.png")!
            }
            
            func compass() -> UIImage {
                return UIImage(named: "compass.png")!
            }

            switch degree.value {
            case 0..<45:
                return compassN()
                
            case 45:
                return compassNE()
                
            case 46..<135:
                return compassE()
                
            case 135:
                return compassSE()
                
            case 136..<225:
                return compassS()
                
            case 225:
                return compassSW()
                
            case 226..<315:
                return compassW()
                
            case 315:
                return compassN()
                
            case 316..<360:
                return compassN()
                
            default:
                return compass()
            }
        }
        
    }
    
    var direction: String {
        get {
            switch self.degree.value {
            case 0..<45:
                return "N"
                
            case 45:
                return "NE"
                
            case 46..<135:
                return "E"
                
            case 135:
                return "SE"
                
            case 136..<225:
                return "S"
                
            case 225:
                return "SW"
                
            case 226..<315:
                return "W"
                
            case 315:
                return "NW"
                
            case 316..<360:
                return "N"
                
            default:
                return "NA"
            }
        }
    }
    
    
    init() {
        self.speed = (value: 0, unit: Unit(quantity: Quantity.Speed))
        self.degree = (value: 0, unit: Unit(quantity: Quantity.Direction))
    }
    
    init(speed: Int, degree: Int) {
        self.speed = (value: speed, unit: Unit(quantity: Quantity.Speed))
        self.degree = (value: degree, unit: Unit(quantity: Quantity.Direction))
    }
}


extension Wind {
    func speedValue() -> Int {
        return self.speed.value
    }
    
    func degreeValue() -> Int {
        return self.degree.value
    }
    
    func speedSymbol() -> String {
        return self.speed.unit.symbol
    }
    
    func degreeSymbol() -> String {
        return self.degree.unit.symbol
    }
}

private extension Wind {
    mutating func changeWindUnitMeasuringSystem(to measuringSystem: MeasuringSystem) {
        self.speed.unit.changeMeasuringSystem(to: measuringSystem)
        self.degree.unit.changeMeasuringSystem(to: measuringSystem)
    }
}


// MARK: Protocol Convertieble
extension Wind: ConditionConvertible {
    
    mutating func convertWhenChangedMeasuringSystem(to sys: MeasuringSystem) {
        func convertMilePerHourToMeterPerSec() {
            guard self.speed.value > 0 else { return }
            
            let oneMilePerHour: Double = 0.44704
            let milePerHour: Int = self.speed.value
            var meterPerSec: Int
            
            if  milePerHour > 0 {
                let roundedResult = (Double(milePerHour) * oneMilePerHour).roundToPlaces(1)
                meterPerSec = Int(roundedResult)
                
                self.speed.value = meterPerSec
            }
        }
        
        func convertMeterPerSecToMilePerHour() {
            guard self.speed.value > 0 else { return }
            
            let oneMeterPerSecond: Double = 2.236936
            let meterPerSec: Int = self.speed.value
            var milePerHour: Int
            
            if  meterPerSec > 0 {
                let roundedResult = (Double(meterPerSec) * oneMeterPerSecond).roundToPlaces(1)
                milePerHour = Int(roundedResult)
                
                self.speed.value = milePerHour
            }
        }
        
        self.changeWindUnitMeasuringSystem(to: sys)
        
        (self.speed.unit.measuringSystem.description != MeasuringSystem.Imperial.description) == true
            ? convertMilePerHourToMeterPerSec() : convertMeterPerSecToMilePerHour()
    }
    
}

// MARK: Protocol Equatable
func ==(lhs: Wind, rhs: Wind) -> Bool {
    if lhs.speed.unit == rhs.speed.unit &&
        lhs.speed.value == rhs.speed.value &&
        lhs.degree.unit == rhs.degree.unit &&
        lhs.degree.value == rhs.degree.value {
        return true
    }
    return false
}
