import UIKit

final class ConditionView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var valueLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(symbol: String, value: String) {
        let symbolConfiguration = UIImage.SymbolConfiguration(
            textStyle: Style.Condition.symbolFont,
            scale: .small
        )
        let bold = UIImage.SymbolConfiguration(weight: Style.Condition.symbolWeight)
        let combined = symbolConfiguration.applying(bold)

        conditionImageView.image = UIImage(
            systemName: symbol,
            withConfiguration: combined
        )
        valueLabel.text = value
    }
}

// MARK: - Private - SetUps
private extension ConditionView {

    func setup() {
        let nibName = ConditionView.nibName
        Bundle.main.loadNibNamed(nibName, owner: self, options: [:])

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupStyle()
    }

    func setupStyle() {
        contentView.backgroundColor = Style.Condition.backgroundColor
        backgroundColor = Style.Condition.backgroundColor

        conditionImageView.tintColor = Style.Condition.textColor
        conditionImageView.contentMode = .scaleAspectFit
        valueLabel.font = Style.Condition.valueFont
        valueLabel.textColor = Style.Condition.textColor
        valueLabel.textAlignment = Style.Condition.textAlignment
    }

}
