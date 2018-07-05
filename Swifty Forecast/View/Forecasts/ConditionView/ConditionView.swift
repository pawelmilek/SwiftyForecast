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
  @IBOutlet private weak var conditionImageView: UIImageView!
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
    contentView.clipsToBounds = true
    clipsToBounds = true
    
    contentView.backgroundColor = .blue
  }
  
  func setupStyle() {
    valueLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
    valueLabel.textColor = .white
    valueLabel.textAlignment = .center
  }
  
}


// MARK: Configurate
extension ConditionView {
  
  func configurate(condition image: UIImage, value: String) {
    conditionImageView.image = image
    valueLabel.text = value
  }
  
}
