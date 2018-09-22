//
//  DailyForecastTableViewCell.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 09/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  typealias DailyForecastCellStyle = Style.DailyForecastCell
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(by: .none)
  }
}


// MARK: - ViewSetupable protocol
extension DailyForecastTableViewCell: ViewSetupable {
  
  func setup() {
    backgroundColor = DailyForecastCellStyle.backgroundColor
  
    dateLabel.textColor = DailyForecastCellStyle.dateLabelTextColor
    dateLabel.textAlignment = DailyForecastCellStyle.dateLabelTextAlignment
    dateLabel.numberOfLines = 2
    
    iconLabel.textColor = DailyForecastCellStyle.iconLabelTextColor
    iconLabel.textAlignment = DailyForecastCellStyle.iconLabelTextAlignment
    
    temperatureLabel.font = DailyForecastCellStyle.temperatureLabelFont
    temperatureLabel.textColor = DailyForecastCellStyle.temperatureLabelTextColor
    temperatureLabel.textAlignment = DailyForecastCellStyle.temperatureLabelTextAlignment
  }
  
}


// MARK: - Configurate cell by item
extension DailyForecastTableViewCell {
  
  func configure(by item: DailyData?) {
    if let daily = item {
      var attributedDateString: NSAttributedString {
        let weekday = daily.date.weekday.uppercased()
        let month = daily.date.longDayMonth.uppercased()
        
        let fullDate = ("\(weekday)\r\n\(month)") as NSString
        let weekdayRange = fullDate.range(of: weekday)
        let monthRange = fullDate.range(of: month)
        
        let attributedString = NSMutableAttributedString(string: fullDate as String)
        attributedString.addAttributes([NSAttributedString.Key.font: DailyForecastCellStyle.weekdayLabelFont], range: weekdayRange)
        attributedString.addAttributes([NSAttributedString.Key.font: DailyForecastCellStyle.monthLabelFont], range: monthRange)
        
        return attributedString
      }
      
      dateLabel.attributedText = attributedDateString
      dateLabel.alpha = 1
      
      let icon = ConditionFontIcon.make(icon: daily.icon, font: DailyForecastCellStyle.conditionFontIconSize)
      iconLabel.attributedText = icon?.attributedIcon
      iconLabel.alpha = 1
      
      temperatureLabel.text = daily.temperatureMaxFormatted
      temperatureLabel.alpha = 1
    } else {
      dateLabel.alpha = 0
      iconLabel.alpha = 0
      temperatureLabel.alpha = 0
    }
  }
}
