//
//  DailyForecastView.swift
//  Pretty Weather
//
//  Created by Pawel Milek on 20/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Cartography


class DailyForecastView: UIView, CustomViewLayoutSetupable, ViewSetupable {
  private var dayCells = [DayForecastView]()
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
extension DailyForecastView {
  
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


// MAKR: CustomViewLayoutSetupable
extension DailyForecastView {
  
  func setupLayout() {
    func setViewConstrain() {
      constrain(self) { view in
        view.height == 300
        return
      }
    }
    
    func setdayCellsConstrain() {
      /*
       * Disable the translation from the autoresizingMask to AutoLayout constraints for the view itself.
       * Cartography disables it, but in this case, we set constraints only on the subviews,
       * leaving the view without explicit constraints.
       */
      self.translatesAutoresizingMaskIntoConstraints = false
      
      constrain(dayCells.first!) { view in
        view.top == view.superview!.top
      }
      
      for index in 1..<dayCells.count {
        let previousCell = dayCells[index - 1]
        let cell = dayCells[index]
        
        constrain(cell, previousCell) { view, view2 in
          view.top == view2.bottom
        }
      }
      
      for cell in dayCells {
        constrain(cell) { view in
          view.left == view.superview!.left
          view.right == view.superview!.right
        }
      }
      
      constrain(dayCells.last!) { view in
        view.bottom == view.superview!.bottom
      }
    }
    
    
    setViewConstrain()
    setdayCellsConstrain()
  }
}

// MARK: - CustomViewSetupable
extension DailyForecastView {
  
  func setup() {
    for _ in 0..<ConstantValue.numberOfDays {
      let cell = DayForecastView(frame: CGRect.zero)
      self.dayCells.append(cell)
      self.addSubview(cell)
    }
  }
  
  func setupStyle() {

  }
  
  
  func renderView(for forecast: DailyForecast) {
    for (index, dayView) in self.dayCells.enumerated() {
      dayView.renderView(for: forecast.data[index])
    }
  }
  
}

