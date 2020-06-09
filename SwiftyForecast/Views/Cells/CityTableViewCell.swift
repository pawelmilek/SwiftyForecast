import UIKit

class CityTableViewCell: UITableViewCell {
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var separatorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
    setUpStyle()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    setUp()
  }
}

// MARK: - ViewSetupable protocol
extension CityTableViewCell: ViewSetupable {
  
  func setUp() {
    currentTimeLabel.text = ""
    currentTimeLabel.alpha = 0
    cityNameLabel.text = ""
    cityNameLabel.alpha = 0
  }
  
  func setUpStyle() {
    backgroundColor = Style.CityCell.backgroundColor
    selectionStyle = .none
    
    currentTimeLabel.font = Style.CityCell.currentTimeLabelFont
    currentTimeLabel.textColor = Style.CityCell.currentTimeLabelTextColor
    currentTimeLabel.textAlignment = Style.CityCell.currentTimeLabelTextAlignment
    
    cityNameLabel.font = Style.CityCell.cityNameLabelFont
    cityNameLabel.textColor = Style.CityCell.cityNameLabelTextColor
    cityNameLabel.textAlignment = Style.CityCell.cityNameLabelTextAlignment
    separatorView.backgroundColor = Style.CityCell.separatorColor
  }
  
}

// MARK: - Configure by city
extension CityTableViewCell {
  
  func configure(by name: String, time localTime: String) {
    currentTimeLabel.text = localTime
    cityNameLabel.text = name
    currentTimeLabel.alpha = 1
    cityNameLabel.alpha = 1
  }
  
}
