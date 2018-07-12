//
//  ConditionView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 04/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class ConditionView: UIView {
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var conditionLabel: UILabel!
  @IBOutlet private weak var valueLabel: UILabel!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
    setupStyle()
  }
}


// MARK: ViewSetupable protocol
extension ConditionView: ViewSetupable {
  
  func setup() {
    let nibName = ConditionView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.layer.cornerRadius = 5
    contentView.clipsToBounds = true
    layer.cornerRadius = 5
    clipsToBounds = true
    
    contentView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    backgroundColor = .clear
  }
  
  func setupStyle() {
    valueLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
    valueLabel.textColor = .black
    valueLabel.textAlignment = .center
    
    conditionLabel.textColor = .black
    conditionLabel.textAlignment = .center
  }
  
}


// MARK: Configurate
extension ConditionView {
  
  func configure(condition icon: FontWeatherIconType, value: String) {
    conditionLabel.attributedText = icon.attributedString(font: 16)
    valueLabel.text = value
  }
  
}
