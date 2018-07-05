//
//  CurrentWeatherView.swift
//  Pretty Weather
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Foundation
import LatoFont
import WeatherIconsKit
import Cartography


class CurrentWeatherView: UIView {
  private var dateLabel = UILabel()
  private var cityLabel = UILabel()
  private var iconLabel = UILabel()
  private var descriptionLabel = UILabel()
  private var currentTemperatureLabel = UILabel()
  private var thermometerLabel = UILabel()
  
  var isConstraints = false
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setup()
    self.setupLayout()
    self.setupStyle()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}



// MARK: - Update Constraints
extension CurrentWeatherView {
  
  override func updateConstraints() {
    if self.isConstraints {
      super.updateConstraints()
      return
    }
    
    self.setupLayout()
    
    super.updateConstraints()
    self.isConstraints = true
  }
}


// MAKR: CustomViewLayoutSetupable protocl
extension CurrentWeatherView: CustomViewLayoutSetupable {
  
  func setupLayout() {
    let margin: CGFloat = 8
    
    func setViewConstrain() {
      constrain(self) { view in
        view.height == 440
      }
    }
    
    func setDateLabelConstrain() {
      constrain(self.dateLabel) { view in
        view.top == view.superview!.top
        view.left == view.superview!.left + margin
        view.right == view.superview!.right - margin
        view.height == 90
      }
    }
    
    func setIconLabelConstrain() {
      constrain(self.iconLabel, self.dateLabel) { view, view2 in
        view.top == view2.bottom
        view.left == view.superview!.left + margin
        view.width == 70
        view.width == view.height
      }
    }
    
    func setDescriptionLabelConstrain() {
      constrain(self.descriptionLabel, self.iconLabel) { view, view2 in
        view.top == view2.top
        view.left == view2.right + margin
        view.height == view2.height
        view.right == view.superview!.right - margin
      }
    }
    
    func setCurrentTemperatureLabelConstrain() {
      constrain(self.currentTemperatureLabel, self.iconLabel) { view, view2 in
        view.top == view2.bottom
        view.left == view2.left
        view.right == view.superview!.right - margin
      }
      
      constrain(self.currentTemperatureLabel, self.cityLabel) { view, view2 in
        view.bottom == view2.top
      }
    }
    
    func setThermometerLabelConstrain() {
      constrain(self.thermometerLabel, self.currentTemperatureLabel) { view, view2 in
        view.top == view2.top
        view.left == view.superview!.left + margin
        view.height == 60
        view.width == 30
      }
      
    }
    
    func setCityLabelConstrain() {
      constrain(self.cityLabel) { view in
        view.bottom == view.superview!.bottom
        view.left == view.superview!.left + margin
        view.right == view.superview!.right - margin
        view.height == 50
      }
    }
    
    
    setViewConstrain()
    setDateLabelConstrain()
    setCityLabelConstrain()
    setIconLabelConstrain()
    setDescriptionLabelConstrain()
    setCurrentTemperatureLabelConstrain()
    setThermometerLabelConstrain()
  }
  
}


// MARK: - ViewSetupable protocol
extension CurrentWeatherView: ViewSetupable {
  
  func setup() {
    self.addSubview(self.dateLabel)
    self.addSubview(self.cityLabel)
    self.addSubview(self.currentTemperatureLabel)
    self.addSubview(self.thermometerLabel)
    self.addSubview(self.iconLabel)
    self.addSubview(self.descriptionLabel)
  }
  
  
  func setupStyle() {
    labelsStyle()
  }
  
}


// MARK: - Set labels style
private extension CurrentWeatherView {
  
  func labelsStyle() {
    let textColor = UIColor.white
    self.dateLabel.font = UIFont.latoFont(ofSize: 48)
    self.dateLabel.textColor = textColor
    self.dateLabel.textAlignment = .center
    
    self.cityLabel.font = UIFont.latoFont(ofSize: 20)
    self.cityLabel.textColor = textColor
    self.cityLabel.textAlignment = .left
    
    self.iconLabel.textColor = textColor
    self.iconLabel.textAlignment = .center
    self.descriptionLabel.font = UIFont.latoFont(ofSize: 20)
    self.descriptionLabel.textColor = textColor
    self.descriptionLabel.textAlignment = .center
    
    self.currentTemperatureLabel.font = UIFont.latoFont(ofSize: 120)
    self.currentTemperatureLabel.textColor = textColor
    self.currentTemperatureLabel.textAlignment = .center
    
    self.thermometerLabel.textColor = textColor
    self.thermometerLabel.textAlignment = .center
  }
  
}


// MARK: - Render view
extension CurrentWeatherView {
  
  func renderView(for forecast: CurrentForecast, and city: City) {
    self.dateLabel.text = forecast.time.longDayMonth
    self.cityLabel.text = city.fullName
    self.descriptionLabel.text = forecast.summary
    self.iconLabel.attributedText = IconType(rawValue: forecast.icon)!.fontIcon
    self.thermometerLabel.attributedText = IconType.thermometer.fontIcon
    self.currentTemperatureLabel.text = forecast.temperatureFormatted
  }
  
}
