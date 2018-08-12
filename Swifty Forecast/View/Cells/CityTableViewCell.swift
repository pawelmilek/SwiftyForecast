//
//  CityTableViewCell.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  
  
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
extension CityTableViewCell: ViewSetupable {
  
  func setup() {
    backgroundColor = .clear
    
    currentTimeLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    currentTimeLabel.textColor = UIColor.blackShade
    currentTimeLabel.textAlignment = .left
    
    cityNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    cityNameLabel.textColor = .white
    cityNameLabel.textAlignment = .left
    
    temperatureLabel.font = UIFont.systemFont(ofSize: 66, weight: .light)
    temperatureLabel.textColor = .white
    temperatureLabel.textAlignment = .right
  }
  
}


// MARK: - Configure by city
extension CityTableViewCell {
  
  func configure(by item: City?) {
    if let city = item {
      currentTimeLabel.text = ""
      currentTimeLabel.alpha = 0
      cityNameLabel.text = city.name + ", " + city.country
      cityNameLabel.alpha = 1
      temperatureLabel.text = ""
      temperatureLabel.alpha = 0
      
    } else {
      currentTimeLabel.text = ""
      currentTimeLabel.alpha = 0
      cityNameLabel.text = ""
      cityNameLabel.alpha = 0
      temperatureLabel.text = ""
      temperatureLabel.alpha = 0
    }
  }
}
