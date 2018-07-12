//
//  HourlyForecastCollectionViewCell.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var timeLabel: UILabel!
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



// MARK: - ViewSetupable
extension HourlyForecastCollectionViewCell: ViewSetupable {
  
  func setup() {
    backgroundColor = .clear
    
    timeLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
    timeLabel.textColor = .white
    timeLabel.textAlignment = .center
    
    iconLabel.textColor = .white
    iconLabel.textAlignment = .center
    
    temperatureLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
    temperatureLabel.textColor = .white
    temperatureLabel.textAlignment = .center
  }
  
}


extension HourlyForecastCollectionViewCell {
  
  func configure(by item: HourlyData?) {
    if let hourly = item {
      timeLabel.text = hourly.date.time
      timeLabel.alpha = 1
      
      let icon = ConditionFontIcon.make(icon: hourly.icon, font: 25)
      iconLabel.attributedText = icon?.attributedIcon
      iconLabel.alpha = 1
      
      temperatureLabel.text = hourly.temperatureFormatted
      temperatureLabel.alpha = 1
    } else {
      timeLabel.alpha = 0
      iconLabel.alpha = 0
      temperatureLabel.alpha = 0
    }
  }
}
