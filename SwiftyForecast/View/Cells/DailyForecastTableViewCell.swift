import UIKit

class DailyForecastTableViewCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
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

// MARK: - ViewSetupable protocol
extension DailyForecastTableViewCell: ViewSetupable {
  
  func setUp() {
    backgroundColor = Style.DailyForecastCell.backgroundColor
  
    dateLabel.textColor = Style.DailyForecastCell.dateLabelTextColor
    dateLabel.textAlignment = Style.DailyForecastCell.dateLabelTextAlignment
    dateLabel.numberOfLines = 2
    
    iconLabel.textColor = Style.DailyForecastCell.iconLabelTextColor
    iconLabel.textAlignment = Style.DailyForecastCell.iconLabelTextAlignment
    
    temperatureLabel.font = Style.DailyForecastCell.temperatureLabelFont
    temperatureLabel.textColor = Style.DailyForecastCell.temperatureLabelTextColor
    temperatureLabel.textAlignment = Style.DailyForecastCell.temperatureLabelTextAlignment
  }
  
}

// MARK: - Configurate cell by item
extension DailyForecastTableViewCell {
  
  func configure(by item: DailyForecastCellViewModel?) {
    if let daily = item {
      dateLabel.attributedText = daily.attributedDate
      dateLabel.alpha = 1
      iconLabel.attributedText = daily.conditionIcon
      iconLabel.alpha = 1
      
      temperatureLabel.text = daily.temperatureMax
      temperatureLabel.alpha = 1
    } else {
      dateLabel.alpha = 0
      iconLabel.alpha = 0
      temperatureLabel.alpha = 0
    }
  }
  
}
