import UIKit

class ConditionView: UIView {
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var conditionLabel: UILabel!
  @IBOutlet private weak var valueLabel: UILabel!
  
  typealias ConditionStyle = Style.Condition
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    setUpStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
    setUpStyle()
  }
}

// MARK: ViewSetupable protocol
extension ConditionView: ViewSetupable {
  
  func setUp() {
    let nibName = ConditionView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    contentView.layer.cornerRadius = ConditionStyle.cornerRadius
    contentView.clipsToBounds = true
    layer.cornerRadius = ConditionStyle.cornerRadius
    clipsToBounds = true
    
    contentView.backgroundColor = ConditionStyle.backgroundColor
    backgroundColor = .clear
  }
  
  func setUpStyle() {
    conditionLabel.textColor = ConditionStyle.textColor
    conditionLabel.textAlignment = ConditionStyle.textAlignment
    
    valueLabel.font = ConditionStyle.valueLabelFont
    valueLabel.textColor = ConditionStyle.textColor
    valueLabel.textAlignment = ConditionStyle.textAlignment
  }
  
}

// MARK: Configurate
extension ConditionView {
  
  func configure(condition icon: FontWeatherIconType, value: String) {
    conditionLabel.attributedText = icon.attributedString(font: ConditionStyle.conditionFontSize)
    valueLabel.text = value
  }
  
}
