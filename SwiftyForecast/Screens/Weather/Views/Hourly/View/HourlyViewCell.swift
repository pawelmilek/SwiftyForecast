import UIKit
import Combine

final class HourlyViewCell: UICollectionViewCell {
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

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
        iconImageView.image = UIImage()
        temperatureLabel.text = ""
    }

    func set(viewModel: HourlyViewCellViewModel) {
        self.viewModel = viewModel
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

    func subscribePublishers() {
        guard let viewModel else { return }

        viewModel.$time
            .sink { [weak self] time in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [self] in
                    self?.timeLabel.alpha = 0.3
                }

                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) { [self] in
                    self?.timeLabel.text = time
                    self?.timeLabel.alpha = 1.0
                }
            }
            .store(in: &cancellables)

        viewModel.$iconURL
            .compactMap { $0 }
            .sink { [weak self] iconURL in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [self] in
                    self?.iconImageView.alpha = 0.3
                }
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) { [self] in
                    self?.iconImageView.kf.setImage(with: iconURL)
                    self?.iconImageView.alpha = 1.0
                }
            }
            .store(in: &cancellables)

        viewModel.$temperature
            .sink { [weak self] temperature in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [self] in
                    self?.temperatureLabel.alpha = 0.3
                }
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) { [self] in
                    self?.temperatureLabel.text = temperature
                    self?.temperatureLabel.alpha = 1.0
                }
            }
            .store(in: &cancellables)
    }
}
