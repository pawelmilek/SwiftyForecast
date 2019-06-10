import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
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
extension HourlyCollectionViewCell: ViewSetupable {
  
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
extension HourlyCollectionViewCell {
  
  func configure(by hourly: HourlyForecastCellViewModel?) {
    if let hourly = hourly {
      timeLabel.text = hourly.time
      iconLabel.attributedText = hourly.conditionIcon
      temperatureLabel.text = hourly.temperature
      timeLabel.alpha = 1
      iconLabel.alpha = 1
      temperatureLabel.alpha = 1
    } else {
      timeLabel.alpha = 0
      iconLabel.alpha = 0
      temperatureLabel.alpha = 0
    }
  }
}
