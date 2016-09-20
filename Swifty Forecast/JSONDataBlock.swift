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

struct JSONDataBlock {
    static let currently = "currently"
    static let hourly = "hourly"
    static let daily = "daily"
    static let data = "data"
    
    struct DataPoint {
        static let time = "time"
        static let icon = "icon"
        static let sunriseTime = "sunriseTime"
        static let sunsetTime = "sunsetTime"
        static let moonPhase = "moonPhase"
        static let temperature = "temperature"
        static let temperatureMin = "temperatureMin"
        static let temperatureMinTime = "temperatureMinTime"
        static let temperatureMax = "temperatureMax"
        static let temperatureMaxTime = "temperatureMaxTime"
        static let windSpeed = "windSpeed"
        static let windBearing = "windBearing"
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let cloudCover = "cloudCover"
        static let summary = "summary"
    }
}
