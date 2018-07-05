//
//  CityCell.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
  @IBOutlet weak var cityNameLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configurate(by: .none)
  }
}



// MARK: - ViewSetupable
extension CityCell: ViewSetupable {
  
  func setup() {
    self.backgroundColor = .clear
    
    self.cityNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    self.cityNameLabel.textColor = .white
    self.cityNameLabel.textAlignment = .left
  }
  
}


extension CityCell {
  
  func configurate(by item: City?) {
    if let city = item {
      cityNameLabel.text = "\(city.name), \(city.country)"
      cityNameLabel.alpha = 1
    } else {
      cityNameLabel.text = ""
      cityNameLabel.alpha = 0
    }
  }
}
