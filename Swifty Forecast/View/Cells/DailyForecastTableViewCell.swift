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
    backgroundColor = .clear
  
    dateLabel.textColor = .blackShade
    dateLabel.textAlignment = .left
    dateLabel.numberOfLines = 2
    
    iconLabel.textColor = .blackShade
    iconLabel.textAlignment = .center
    
    temperatureLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    temperatureLabel.textColor = .blackShade
    temperatureLabel.textAlignment = .center
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
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11, weight: .bold)], range: weekdayRange)
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11, weight: .light)], range: monthRange)
        
        return attributedString
      }
      
      dateLabel.attributedText = attributedDateString
      dateLabel.alpha = 1
      
      let icon = ConditionFontIcon.make(icon: daily.icon, font: 22)
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
