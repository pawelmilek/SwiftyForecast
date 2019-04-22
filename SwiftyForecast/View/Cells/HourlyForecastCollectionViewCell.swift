import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setUp()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(by: .none)
  }
}

// MARK: - ViewSetupable
extension HourlyForecastCollectionViewCell: ViewSetupable {
  
  func setUp() {
    backgroundColor = Style.HourlyForecastCell.backgroundColor
    
    timeLabel.font = Style.HourlyForecastCell.timeLabelFont
    timeLabel.textColor = Style.HourlyForecastCell.timeLabelTextColor
    timeLabel.textAlignment = Style.HourlyForecastCell.timeLabelTextAlignment
    
    iconLabel.textColor = Style.HourlyForecastCell.iconLabelTextColor
    iconLabel.textAlignment = Style.HourlyForecastCell.iconLabelTextAlignment
    
    temperatureLabel.font = Style.HourlyForecastCell.temperatureLabelFont
    temperatureLabel.textColor = Style.HourlyForecastCell.temperatureLabelTextColor
    temperatureLabel.textAlignment = Style.HourlyForecastCell.temperatureLabelTextAlignment
  }
  
}

// MARK: - Configure
extension HourlyForecastCollectionViewCell {
  
  func configure(by hourly: HourlyDataViewModel?) {
    if let hourly = hourly {
      timeLabel.text = hourly.time
      timeLabel.alpha = 1
      iconLabel.attributedText = hourly.conditionIcon
      iconLabel.alpha = 1
      temperatureLabel.text = hourly.temperature
      temperatureLabel.alpha = 1
    } else {
      timeLabel.alpha = 0
      iconLabel.alpha = 0
      temperatureLabel.alpha = 0
    }
  }
}
