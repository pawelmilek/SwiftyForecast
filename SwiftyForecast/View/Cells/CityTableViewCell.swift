import UIKit

class CityTableViewCell: UITableViewCell {
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var separatorView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(by: .none)
  }
}

// MARK: - ViewSetupable protocol
extension CityTableViewCell: ViewSetupable {
  
  func setUp() {
    backgroundColor = Style.CityCell.backgroundColor
    selectionStyle = .none
    
    currentTimeLabel.font = Style.CityCell.currentTimeLabelFont
    currentTimeLabel.textColor = Style.CityCell.currentTimeLabelTextColor
    currentTimeLabel.textAlignment = Style.CityCell.currentTimeLabelTextAlignment
    
    cityNameLabel.font = Style.CityCell.cityNameLabelFont
    cityNameLabel.textColor = Style.CityCell.cityNameLabelTextColor
    cityNameLabel.textAlignment = Style.CityCell.cityNameLabelTextAlignment
    separatorView.backgroundColor = Style.CityCell.separatorColor
    configure(by: .none)
  }
  
}

// MARK: - Configure by city
extension CityTableViewCell {
  
  func configure(by city: City?, localTime: String? = nil) {
    if let city = city, let localTime = localTime {
      currentTimeLabel.text = localTime
      currentTimeLabel.alpha = 1
      cityNameLabel.text = city.name + ", " + city.country
      cityNameLabel.alpha = 1
      
    } else if let city = city {
      currentTimeLabel.text = city.localTime
      currentTimeLabel.alpha = 1
      cityNameLabel.text = city.name + ", " + city.country
      cityNameLabel.alpha = 1
      
    } else {
      currentTimeLabel.text = ""
      currentTimeLabel.alpha = 0
      cityNameLabel.text = ""
      cityNameLabel.alpha = 0
    }
  }
  
}
