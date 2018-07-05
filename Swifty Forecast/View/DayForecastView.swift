//
//  DayForecastView.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import Cartography

final class DayForecastView: UIView, CustomViewLayoutSetupable, ViewSetupable  {
  private let iconLabel = UILabel()
  private let moonPhaseLabel = UILabel()
  private let dateLabel = UILabel()
  private let temperaturesLabel = UILabel()
  private let descriptionLabel = UILabel()
  var isConstraints = false
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setup()
    self.setupStyle()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: - Update Constraints
extension DayForecastView {
  
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


// MARK: - CustomViewLayoutSetupable
extension DayForecastView {
  
  func setupLayout() {
    let mergin: CGFloat = 8
    
    func setViewConstrain() {
      constrain(self) { view in
        view.height == 60
        return
      }
    }
    
    func setIconLabelConstrain() {
      constrain(self.iconLabel) { view in
        view.centerY == view.superview!.centerY
        view.left == view.superview!.left + mergin
        view.width == view.height
        view.height == 60
      }
    }
    
    func setMoonPhaseLabelConstrain() {
      constrain(self.moonPhaseLabel, self.iconLabel) { view, view2 in
        view.centerY == view.superview!.centerY
        view.left == view2.right + mergin
        view.width == view.height
        view.height == 40
      }
    }
    
    func setDateLabelConstrain() {
      constrain(self.dateLabel, self.moonPhaseLabel) { view, view2 in
        view.top == view.superview!.top
        view.left == view2.right + mergin
        //view.height == 10
      }
    }
    
    func setTemperaturesLabelConstrain() {
      constrain(self.temperaturesLabel) { view in
        view.centerY == view.superview!.centerY
        view.right == view.superview!.right - mergin
      }
    }
    
    func setDescriptionLabelConstrain() {
      constrain(self.descriptionLabel, self.moonPhaseLabel) { view, view2 in
        view.top == view.superview!.centerY
        view.bottom == view.superview!.bottom
        view.left == view2.right + mergin
        view.right == view.superview!.right - mergin
      }
      
      constrain(self.descriptionLabel, self.dateLabel) { view, view2 in
        view.height == view2.height
      }
    }
    
    setViewConstrain()
    setIconLabelConstrain()
    setMoonPhaseLabelConstrain()
    setDateLabelConstrain()
    setTemperaturesLabelConstrain()
    setDescriptionLabelConstrain()
    
  }
}

// MARK: - CustomViewSetupable
extension DayForecastView {
  
  func setup() {
    self.addSubview(self.iconLabel)
    self.addSubview(self.moonPhaseLabel)
    self.addSubview(self.dateLabel)
    self.addSubview(self.temperaturesLabel)
    self.addSubview(self.descriptionLabel)
  }
  
  
  func setupStyle() {
    func setLabelsAttribute() {
      let textColor = UIColor.white
      
      self.iconLabel.textColor = textColor
      self.iconLabel.textAlignment = .center
      self.moonPhaseLabel.textColor = textColor
      self.moonPhaseLabel.textAlignment = .center
      self.dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      self.dateLabel.textColor = textColor
      self.dateLabel.textAlignment = .left
      self.temperaturesLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
      self.temperaturesLabel.textColor = textColor
      self.temperaturesLabel.textAlignment = .right
      self.descriptionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
      self.descriptionLabel.textColor = textColor
      self.descriptionLabel.textAlignment = .left
    }
    setLabelsAttribute()
  }
  
  func renderView(for forecast: DailyData) {
    self.dateLabel.text = "\(forecast.time.mediumDayMonth), \(forecast.time.weekday)"
    self.iconLabel.attributedText = IconType(rawValue: forecast.icon)!.fontIcon
    self.moonPhaseLabel.attributedText = forecast.moonPhase.icon
    self.descriptionLabel.text = forecast.summary
    self.temperaturesLabel.text = "\(forecast.temperatureMaxFormatted)/\(forecast.temperatureMinFormatted)"
  }
}

