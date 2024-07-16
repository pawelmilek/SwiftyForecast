import UIKit
import Combine

final class HourlyViewCell: UICollectionViewCell {
    private struct Style {
        static let timeFont = UIFont.preferredFont(for: .caption1, weight: .semibold, design: .monospaced)
        static let timeColor = UIColor.accent
        static let timeAlignment = NSTextAlignment.center
        static let temperatureFont = UIFont.preferredFont(for: .body, weight: .bold, design: .monospaced)
        static let temperatureColor = UIColor.accent
        static let temperatureAlignment = NSTextAlignment.right
        static let iconContentMode = UIView.ContentMode.scaleAspectFit

        static let cornerRadius = CGFloat(13)
        static let shadowRadius = CGFloat(0)
        static let shadowOpacity = Float(1.0)
        static let shadowOffset = CGSize(width: 2.5, height: 2.5)

        static let iconShadowRadius = CGFloat(0.5)
        static let iconShadowOpacity = Float(1.0)
        static let iconShadowOffset = CGSize(width: 1, height: 1)
        static let iconShadowColor = UIColor.white.cgColor
    }

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HourlyViewCellViewModel? {
        didSet {
            subscribePublishers()
            viewModel?.render()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func set(viewModel: HourlyViewCellViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private - Setups
private extension HourlyViewCell {

    func setup() {
        timeLabel.font = Style.timeFont
        timeLabel.textColor = Style.timeColor
        timeLabel.textAlignment = Style.timeAlignment

        iconImageView.contentMode = Style.iconContentMode
        iconImageView.layer.shadowRadius = Style.iconShadowRadius
        iconImageView.layer.shadowOpacity = Style.iconShadowOpacity
        iconImageView.layer.shadowOffset = Style.iconShadowOffset
        iconImageView.layer.shadowColor = Style.iconShadowColor
        iconImageView.layer.masksToBounds = false

        temperatureLabel.font = Style.temperatureFont
        temperatureLabel.textColor = Style.temperatureColor
        temperatureLabel.textAlignment = Style.temperatureAlignment

        contentView.backgroundColor = .customPrimary
        setRoundedCornersAndBorder()
        registerTraitUserInterfaceStyleObserver()
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
        contentView.layer.shadowOffset = Style.shadowOffset
        contentView.layer.shadowOpacity = Style.shadowOpacity
        contentView.layer.shadowRadius = Style.shadowRadius
    }

    @objc
    func setRoundedCornersAndBorder() {
        contentView.layer.cornerRadius = Style.cornerRadius
        layer.masksToBounds = false
        setupShadow()
    }

    func subscribePublishers() {
        guard let viewModel else { return }

        viewModel.$time
            .sink { [weak self] time in
                self?.timeLabel.text = time
            }
            .store(in: &cancellables)

        viewModel.$iconURL
            .compactMap { $0 }
            .sink { [weak self] iconURL in
                self?.iconImageView.kf.setImage(with: iconURL)
            }
            .store(in: &cancellables)

        viewModel.$temperature
            .sink { [weak self] temperature in
                self?.temperatureLabel.text = temperature
            }
            .store(in: &cancellables)
    }
}
