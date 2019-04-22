import UIKit

class DailyForecastTableViewCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var iconLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  typealias DailyForecastCellStyle = Style.DailyForecastCell
  private var viewModel: DailyDataViewModel?
  
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
  
  func configure(by item: DailyDataViewModel?) {
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
