import UIKit

class ConditionView: UIView {
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var conditionLabel: UILabel!
  @IBOutlet private weak var valueLabel: UILabel!
  
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
    contentView.layer.cornerRadius = Style.Condition.cornerRadius
    contentView.clipsToBounds = true
    layer.cornerRadius = Style.Condition.cornerRadius
    clipsToBounds = true
    
    contentView.backgroundColor = Style.Condition.backgroundColor
    backgroundColor = .clear
  }
  
  func setUpStyle() {
    conditionLabel.textColor = Style.Condition.textColor
    conditionLabel.textAlignment = Style.Condition.textAlignment
    
    valueLabel.font = Style.Condition.valueLabelFont
    valueLabel.textColor = Style.Condition.textColor
    valueLabel.textAlignment = Style.Condition.textAlignment
  }
  
}

// MARK: Configurate
extension ConditionView {
  
  func configure(condition icon: FontWeatherIconType, value: String) {
    conditionLabel.attributedText = icon.attributedString(font: Style.Condition.conditionFontSize)
    valueLabel.text = value
  }
  
}
