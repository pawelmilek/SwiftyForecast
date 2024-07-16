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
    struct Style {
        static let backgroundColor = UIColor.clear

        static let dateColor = UIColor.accent
        static let dateAlignment = NSTextAlignment.left
        static let numberOfLines = 2

        static let iconColor = UIColor.accent
        static let iconAlignment = NSTextAlignment.center

        static let temperatureFont = UIFont.preferredFont(for: .title3, weight: .bold, design: .monospaced)
        static let temperatureColor = UIColor.accent
        static let temperatureAlignment = NSTextAlignment.center

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOpacity = Float(1.0)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
    }

    func setup() {
        backgroundColor = Style.backgroundColor
        dateLabel.textColor = Style.dateColor
        dateLabel.textAlignment = Style.dateAlignment
        dateLabel.numberOfLines = Style.numberOfLines
        temperatureLabel.font = Style.temperatureFont
        temperatureLabel.textColor = Style.temperatureColor
        temperatureLabel.textAlignment = Style.temperatureAlignment
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
        iconImageView.layer.shadowRadius = Style.iconShadowRadius
        iconImageView.layer.shadowOpacity = Style.iconShadowOpacity
        iconImageView.layer.shadowOffset = Style.iconShadowOffset
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
