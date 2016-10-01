//
//  ForecastDate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct ForecastDate {
    var dayMonth: String
    var weekday: String
    var time: String

    
    init(timeStamp: Int) {
        let timeStamp = TimeInterval(timeStamp)
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM"
        
        let date = Date(timeIntervalSince1970: timeStamp)
        let shortDate = formatter.string(from: date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: date)
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: date)
        
        
        self.dayMonth = shortDate
        self.weekday = weekday
        self.time = time
    }
}


// MARK: CustomStringConvertible
extension ForecastDate: CustomStringConvertible {
    var description: String {
        let textualRepresentation = "\(self.dayMonth), \(self.weekday) \(self.time)"
        return textualRepresentation
    }
}
