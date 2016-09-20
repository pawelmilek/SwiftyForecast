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


struct DateTime: Equatable {
    var dayAndMonth: String
    var weekday: String
    var time: String

    
    init(timeStamp: Int) {
        let timeStamp = NSTimeInterval(timeStamp)
        let formatter = NSDateFormatter()
        
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "dd MMMM"
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let shortDate = formatter.stringFromDate(date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(date)
        
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        let time = formatter.stringFromDate(date)
        
        self.dayAndMonth = shortDate
        self.weekday = weekday
        self.time = time
    }
}

extension DateTime: CustomStringConvertible {
    var description: String {
        get {
            let desc: String = "\(self.dayAndMonth), \(self.weekday) \(self.time)"

            return desc
        }
    }
}

func ==(lhs: DateTime, rhs: DateTime) -> Bool {
    if lhs.dayAndMonth == rhs.dayAndMonth && lhs.weekday == rhs.weekday && lhs.time == rhs.time {
        return true
    }
    return false
}
