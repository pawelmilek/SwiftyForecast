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


struct MoonPhase: Equatable {
    private var lunationNumber: Double
    var image: UIImage? {
        get {
            if let icon = Icon(rawValue: self.description) {
               return icon.image
            }
            return nil
        }
    }
    
    
    init(lunationNumber: Double) {
        self.lunationNumber = lunationNumber
    }
}


extension MoonPhase: CustomStringConvertible {
    var description: String {
        get {
            switch self.lunationNumber {
            case 0:
                return "New moon"
                
            case 0.01..<0.25:
                return "Waxing crescent"
                
            case 0.25:
                return "First quarter moon"
                
            case 0.26..<0.5:
                return "Waxing gibbous"
                
            case 0.5:
                return "Full moon"
                
            case 0.51..<0.75:
                return "Waning gibbous"
                
            case 0.75:
                return "Last quarter moon"
                
            case 0.76...1.0:
                return "Waning crescent"
                
            default:
                return "NA"
            }
        }
    }
}

func ==(lhs: MoonPhase, rhs: MoonPhase) -> Bool {
    if lhs.lunationNumber == rhs.lunationNumber && lhs.description == rhs.description {
        return true
    }
    return false
}
