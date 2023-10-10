import UIKit

final class DailyViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.attributedText = NSAttributedString()
        iconImageView.image = UIImage()
        temperatureLabel.text = ""
    }
}

// MARK: - Private - SetUps
private extension DailyViewCell {

    func setUp() {
        backgroundColor = Style.DailyCell.backgroundColor

        dateLabel.textColor = Style.DailyCell.dateColor
        dateLabel.textAlignment = Style.DailyCell.dateAlignment
        dateLabel.numberOfLines = 2

        temperatureLabel.font = Style.DailyCell.temperatureFont
        temperatureLabel.textColor = Style.DailyCell.temperatureColor
        temperatureLabel.textAlignment = Style.DailyCell.temperatureAlignment
    }

}
