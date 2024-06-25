import UIKit
import Combine
import Kingfisher

final class DailyViewCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    private var cancellables = Set<AnyCancellable>()
    private var viewModel: DailyViewCellViewModel? {
        didSet {
            subscribePublishers()
            viewModel?.render()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func set(viewModel: DailyViewCellViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private - Setups
private extension DailyViewCell {

    func setup() {
        backgroundColor = Style.DailyCell.backgroundColor
        dateLabel.textColor = Style.DailyCell.dateColor
        dateLabel.textAlignment = Style.DailyCell.dateAlignment
        dateLabel.numberOfLines = Style.DailyCell.numberOfLines
        temperatureLabel.font = Style.DailyCell.temperatureFont
        temperatureLabel.textColor = Style.DailyCell.temperatureColor
        temperatureLabel.textAlignment = Style.DailyCell.temperatureAlignment
        setupConditionIconShadow()
        registerTraitUserInterfaceStyleObserver()
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

    func subscribePublishers() {
        guard let viewModel else { return }

        viewModel.$attributedDate
            .sink { [weak self] attributedDate in
                self?.dateLabel.attributedText = attributedDate
            }
            .store(in: &cancellables)

        viewModel.$temperature
            .sink { [weak self] temperature in
                self?.temperatureLabel.text = temperature
            }
            .store(in: &cancellables)

        viewModel.$iconURL
            .compactMap { $0 }
            .sink { [weak self] iconURL in
                self?.iconImageView.kf.setImage(with: iconURL)
            }
            .store(in: &cancellables)
    }
}
