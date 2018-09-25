//
//  CityTableViewCell.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var separatorView: UIView!
  
  typealias CityCellStyle = Style.CityCell
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(by: .none)
  }
}



// MARK: - ViewSetupable protocol
extension CityTableViewCell: ViewSetupable {
  
  func setup() {
    backgroundColor = CityCellStyle.backgroundColor
    selectionStyle = .none
    
    currentTimeLabel.font = CityCellStyle.currentTimeLabelFont
    currentTimeLabel.textColor = CityCellStyle.currentTimeLabelTextColor
    currentTimeLabel.textAlignment = CityCellStyle.currentTimeLabelTextAlignment
    
    cityNameLabel.font = CityCellStyle.cityNameLabelFont
    cityNameLabel.textColor = CityCellStyle.cityNameLabelTextColor
    cityNameLabel.textAlignment = CityCellStyle.cityNameLabelTextAlignment
    separatorView.backgroundColor = CityCellStyle.separatorColor
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
