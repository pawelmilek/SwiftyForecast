import UIKit
import Kingfisher

protocol CurrentWeatherViewDelegate: AnyObject {
    func currentWeatherView(
        _ view: CurrentWeatherView,
        numberOfHourlyItemsInSection section: Int
    ) -> Int
    func currentWeatherView(
        _ view: CurrentWeatherView,
        hourlyDataForItemAt indexPath: IndexPath
    ) -> HourlyForecastData?
}

final class CurrentWeatherView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayNightLabel: UILabel!
    @IBOutlet weak var conditionDescription: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureMaxMinLabel: UILabel!
    @IBOutlet weak var windView: ConditionView!
    @IBOutlet weak var humidityView: ConditionView!
    @IBOutlet weak var sunriseView: ConditionView!
    @IBOutlet weak var sunsetView: ConditionView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var moreDetailsView: UIView!

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage.background
        imageView.layer.masksToBounds = true
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()

    weak var delegate: CurrentWeatherViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func loadHourlyData() {
        hourlyCollectionView.reloadData()
    }
}

// MARK: - Private - SetUps
private extension CurrentWeatherView {

    func setUp() {
        createContentView()
        setShadowForBaseView()
        setRoundedCornersForContentView()
        setCollectionView()
        setUpStyle()
    }

    func setUpStyle() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = Style.Current.textColor

        dayNightLabel.font = Style.Current.conditionDescriptionFont
        dayNightLabel.textColor = Style.Current.textColor
        dayNightLabel.textAlignment = Style.Current.textAlignment

        conditionDescription.font = Style.Current.conditionDescriptionFont
        conditionDescription.textColor = Style.Current.textColor
        conditionDescription.textAlignment = Style.Current.textAlignment

        temperatureMaxMinLabel.font = Style.Current.subTemperatureFont
        temperatureMaxMinLabel.textColor = Style.Current.textColor
        temperatureMaxMinLabel.textAlignment = Style.Current.textAlignment

        dateLabel.font = Style.Current.dateFont
        dateLabel.textColor = Style.Current.textColor
        dateLabel.textAlignment = Style.Current.textAlignment

        locationName.font = Style.Current.cityNameFont
        locationName.textColor = Style.Current.textColor
        locationName.textAlignment = Style.Current.textAlignment

        temperatureLabel.font = Style.Current.temperatureFont
        temperatureLabel.textColor = Style.Current.textColor
        temperatureLabel.textAlignment = Style.Current.textAlignment

        moreDetailsView.backgroundColor = Style.Current.backgroundColor
        hourlyCollectionView.backgroundColor = Style.Current.backgroundColor
    }

}

// MARK: - Set bottom shadow
private extension CurrentWeatherView {

    func createContentView() {
        let nibName = CurrentWeatherView.nibName
        Bundle.main.loadNibNamed(nibName, owner: self, options: [:])

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(backgroundImageView)
        contentView.sendSubviewToBack(backgroundImageView)
    }

}

// MARK: - Set bottom shadow
private extension CurrentWeatherView {

    func setShadowForBaseView() {
        backgroundColor = Style.Current.backgroundColor
        layer.shadowColor = Style.Current.shadowColor
        layer.shadowOffset = Style.Current.shadowOffset
        layer.shadowOpacity = Style.Current.shadowOpacity
        layer.shadowRadius = Style.Current.shadowRadius
        layer.masksToBounds = false
    }

    func setRoundedCornersForContentView() {
        contentView.layer.cornerRadius = Style.Current.cornerRadius
        contentView.layer.masksToBounds = true
    }
}

// MARK: - Set collection view
private extension CurrentWeatherView {

    func setCollectionView() {
        hourlyCollectionView.register(cellClass: HourlyViewCell.self)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        hourlyCollectionView.showsVerticalScrollIndicator = false
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        hourlyCollectionView.contentInsetAdjustmentBehavior = .never
    }

}

// MARK: - UICollectionViewDataSource protocol
extension CurrentWeatherView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.currentWeatherView(self, numberOfHourlyItemsInSection: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyViewCell.reuseIdentifier,
            for: indexPath
        ) as? HourlyViewCell else {
            return HourlyViewCell()
        }

        guard let item = delegate?.currentWeatherView(self, hourlyDataForItemAt: indexPath) else {
            return cell
        }

        cell.iconImageView.kf.setImage(with: item.iconURL)
        cell.timeLabel.text = item.time
        cell.temperatureLabel.text = item.temperature
        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout protocol
extension CurrentWeatherView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 70)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }

}
