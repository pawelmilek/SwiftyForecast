import UIKit

final class HourlyViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
        iconImageView.image = UIImage()
        temperatureLabel.text = ""
    }
}

// MARK: - Private - SetUps
private extension HourlyViewCell {

    func setUp() {
        backgroundColor = Style.HourlyCell.backgroundColor
        timeLabel.font = Style.HourlyCell.timeFont
        timeLabel.textColor = Style.HourlyCell.timeColor
        timeLabel.textAlignment = Style.HourlyCell.timeAlignment
        iconImageView.contentMode = .scaleAspectFit
        temperatureLabel.font = Style.HourlyCell.temperatureFont
        temperatureLabel.textColor = Style.HourlyCell.temperatureColor
        temperatureLabel.textAlignment = Style.HourlyCell.temperatureAlignment
    }

}
