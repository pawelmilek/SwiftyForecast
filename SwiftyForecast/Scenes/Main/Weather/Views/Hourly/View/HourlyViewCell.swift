import UIKit

final class HourlyViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        registerTraitUserInterfaceStyleObserver()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
        iconImageView.image = UIImage()
        temperatureLabel.text = ""
    }
}

// MARK: - Private - Setups
private extension HourlyViewCell {

    func setup() {
        timeLabel.font = Style.HourlyCell.timeFont
        timeLabel.textColor = Style.HourlyCell.timeColor
        timeLabel.textAlignment = Style.HourlyCell.timeAlignment

        iconImageView.contentMode = Style.HourlyCell.iconContentMode
        iconImageView.layer.shadowRadius = Style.HourlyCell.iconShadowRadius
        iconImageView.layer.shadowOpacity = Style.HourlyCell.iconShadowOpacity
        iconImageView.layer.shadowOffset = Style.HourlyCell.iconShadowOffset
        iconImageView.layer.shadowColor = Style.HourlyCell.iconShadowColor
        iconImageView.layer.masksToBounds = false

        temperatureLabel.font = Style.HourlyCell.temperatureFont
        temperatureLabel.textColor = Style.HourlyCell.temperatureColor
        temperatureLabel.textAlignment = Style.HourlyCell.temperatureAlignment
        contentView.backgroundColor = .customPrimary
        setRoundedCornersAndBorder()
    }

    func registerTraitUserInterfaceStyleObserver() {
        self.registerForTraitChanges(
            [UITraitUserInterfaceStyle.self],
            target: self,
            action: #selector(setRoundedCornersAndBorder)
        )
    }

    func setupShadow() {
        contentView.layer.shadowColor = UIColor.shadow.cgColor
        contentView.layer.shadowOffset = Style.HourlyCell.shadowOffset
        contentView.layer.shadowOpacity = Style.HourlyCell.shadowOpacity
        contentView.layer.shadowRadius = Style.HourlyCell.shadowRadius
    }

    @objc
    func setRoundedCornersAndBorder() {
        contentView.layer.cornerRadius = Style.HourlyCell.cornerRadius
        layer.masksToBounds = false
        setupShadow()
    }
}
