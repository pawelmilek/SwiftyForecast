//
//  ForecastDate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct ForecastDate {
    var mediumDayMonth: String
    var longDayMonth: String
    var weekday: String
    var time: String

    
    init(timeStamp: Int) {
        let timeStamp = TimeInterval(timeStamp)
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: timeStamp)
        
        
        formatter.dateFormat = "dd MMMM"
        let longDate = formatter.string(from: date)
        
        
        formatter.dateFormat = "dd MMM"
        let mediumDate = formatter.string(from: date)
    
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: date)
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: date)
        
        
    
        self.mediumDayMonth = mediumDate
        self.longDayMonth = longDate
        self.weekday = weekday
        self.time = time
    }
}


// MARK: CustomStringConvertible
extension ForecastDate: CustomStringConvertible {
    var description: String {
        let textualRepresentation = "\(self.longDayMonth), \(self.weekday) \(self.time)"
        return textualRepresentation
    }
}
