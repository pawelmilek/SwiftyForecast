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

struct SunState: Equatable {
    private(set) var sunriseTime: String
    private(set) var sunsetTime: String
    
    
    init(sunrise: Int, sunset: Int) {
        let sunriseTimeStamp = DateTime(timeStamp: sunrise)
        let sunsetTimeStamp = DateTime(timeStamp: sunset)
        
        self.sunriseTime = sunriseTimeStamp.time
        self.sunsetTime = sunsetTimeStamp.time
    }
}

func ==(lhs: SunState, rhs: SunState) -> Bool {
    if lhs.sunriseTime == rhs.sunriseTime && lhs.sunsetTime == rhs.sunriseTime {
        return true
    }
    
    return false
}
