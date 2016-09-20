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


struct Atmosphere: Equatable {
    var pressure: (value: Int, unit: Unit)
    var humidity: (value: Int, unit: Unit)
    var cloudiness: (value: Int, unit: Unit)
    
    
    init(pressureAndHumidity: (pressure: Int, humidity: Int), cloudiness: Int) {
        self.pressure = (value: pressureAndHumidity.pressure, unit: Unit(quantity: Quantity.Pressure))
        self.humidity = (value: pressureAndHumidity.humidity, unit: Unit(quantity: Quantity.Humidity))
        self.cloudiness = (value: cloudiness, unit: Unit(quantity: Quantity.Cloudiness))
    }
}


// MARK: Protocol Equatable
func ==(lhs: Atmosphere, rhs: Atmosphere) -> Bool {
    if lhs.pressure == rhs.pressure && lhs.humidity == rhs.humidity && lhs.cloudiness == rhs.cloudiness {
        return true
    }
    
    return false
}
