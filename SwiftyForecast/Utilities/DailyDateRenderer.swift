//
//  DailyDateRenderer.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct DailyDateRenderer {
  static func render(_ date: Date) -> NSAttributedString {
    let formatter = DateFormatter()

    formatter.dateFormat = "MMMM d"
    let month = formatter.string(from: date).uppercased()

    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date).uppercased()

    let fullDate = ("\(weekday)\r\n\(month)") as NSString
    let weekdayRange = fullDate.range(of: weekday)
    let monthRange = fullDate.range(of: month)

    let attributedString = NSMutableAttributedString(string: fullDate as String)
    attributedString.addAttributes([.font: Style.DailyCell.weekdayFont], range: weekdayRange)
    attributedString.addAttributes([.font: Style.DailyCell.monthFont], range: monthRange)
    return attributedString
  }
}
