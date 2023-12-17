import UIKit

final class DailyViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        registerTraitUserInterfaceStyleObserver()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.attributedText = NSAttributedString()
        iconImageView.image = UIImage()
        temperatureLabel.text = ""
    }
}

// MARK: - Private - Setups
private extension DailyViewCell {

    func setup() {
        backgroundColor = Style.DailyCell.backgroundColor

        dateLabel.textColor = Style.DailyCell.dateColor
        dateLabel.textAlignment = Style.DailyCell.dateAlignment
        dateLabel.numberOfLines = 1

        temperatureLabel.font = Style.DailyCell.temperatureFont
        temperatureLabel.textColor = Style.DailyCell.temperatureColor
        temperatureLabel.textAlignment = Style.DailyCell.temperatureAlignment
        setupConditionIconShadow()
    }

    func registerTraitUserInterfaceStyleObserver() {
        self.registerForTraitChanges(
            [UITraitUserInterfaceStyle.self],
            target: self,
            action: #selector(setupConditionIconShadow)
        )
    }

    @objc
    func setupConditionIconShadow() {
        iconImageView.layer.shadowRadius = Style.DailyCell.iconShadowRadius
        iconImageView.layer.shadowOpacity = Style.DailyCell.iconShadowOpacity
        iconImageView.layer.shadowOffset = Style.DailyCell.iconShadowOffset
        iconImageView.layer.shadowColor = UIColor.shadow.cgColor
        iconImageView.layer.masksToBounds = false
    }
}
