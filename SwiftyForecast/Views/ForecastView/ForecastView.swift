import UIKit

final class ForecastView: UIView {
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var windView: ConditionView!
  @IBOutlet private weak var humidityView: ConditionView!
  @IBOutlet private weak var sunriseView: ConditionView!
  @IBOutlet private weak var sunsetView: ConditionView!
  @IBOutlet private weak var hourlyCollectionView: UICollectionView!
  @IBOutlet private weak var moreDetailsView: UIView!
  @IBOutlet weak var moreDetailsViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var stackViewBottomToMoreDetailsTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var stackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint!
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "background")
    imageView.layer.masksToBounds = true
    imageView.frame = contentView.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return imageView
  }()
  
  private var viewDidExpand = false
  private var viewModels: [HourlyForecastCellViewModel]?
  private var hourlyCount: Int {
    return viewModels?.count ?? 0
  }
  
  weak var delegate: ForecastViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    setUpStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
    setUpLayout()
    setUpStyle()
  }
}

// MARK: - Private - SetUps
private extension ForecastView {
  
  func setUp() {
    createContentView()
    setShadowForBaseView()
    setRoundedCornersForContentView()
    setCollectionView()
    addTapGestureRecognizer()
  }
  
  func setUpLayout() {
    temperatureLabel.alpha = 0
    iconLabel.alpha = 0
    dateLabel.alpha = 0
    cityNameLabel.alpha = 0
    windView.alpha = 0
    humidityView.alpha = 0
    sunriseView.alpha = 0
    sunsetView.alpha = 0
    moreDetailsView.alpha = 0
  }
  
  func setUpStyle() {
    iconLabel.textColor = Style.CurrentForecast.textColor
    iconLabel.textAlignment = Style.CurrentForecast.textAlignment
    
    dateLabel.font = Style.CurrentForecast.dateLabelFont
    dateLabel.textColor = Style.CurrentForecast.textColor
    dateLabel.textAlignment = Style.CurrentForecast.textAlignment
    
    cityNameLabel.font = Style.CurrentForecast.cityNameLabelFont
    cityNameLabel.textColor = Style.CurrentForecast.textColor
    cityNameLabel.textAlignment = Style.CurrentForecast.textAlignment
    
    temperatureLabel.font = Style.CurrentForecast.temperatureLabelFont
    temperatureLabel.textColor = Style.CurrentForecast.textColor
    temperatureLabel.textAlignment = Style.CurrentForecast.textAlignment
    
    moreDetailsView.backgroundColor = Style.CurrentForecast.backgroundColor
    hourlyCollectionView.backgroundColor = Style.CurrentForecast.backgroundColor
  }
  
}

// MARK: - Set bottom shadow
private extension ForecastView {
  
  func createContentView() {
    let nibName = ForecastView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    contentView.addSubview(backgroundImageView)
    contentView.sendSubviewToBack(backgroundImageView)
  }
  
}

// MARK: - Set bottom shadow
private extension ForecastView {
  
  func setShadowForBaseView() {
    backgroundColor = Style.CurrentForecast.backgroundColor
    layer.shadowColor = Style.CurrentForecast.shadowColor
    layer.shadowOffset = Style.CurrentForecast.shadowOffset
    layer.shadowOpacity = Style.CurrentForecast.shadowOpacity
    layer.shadowRadius = Style.CurrentForecast.shadowRadius
    layer.masksToBounds = false
  }
  
  func setRoundedCornersForContentView() {
    contentView.layer.cornerRadius = Style.CurrentForecast.cornerRadius
    contentView.layer.masksToBounds = true
  }
}

// MARK: - Set collection view
private extension ForecastView {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyCollectionViewCell.self)
    hourlyCollectionView.dataSource = self
    hourlyCollectionView.delegate = self
    hourlyCollectionView.showsVerticalScrollIndicator = false
    hourlyCollectionView.showsHorizontalScrollIndicator = false
  }
  
}

// MARK: - Private - Add tap gesture recognizer
private extension ForecastView {
  
  func addTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    addGestureRecognizer(tapGestureRecognizer)
    isUserInteractionEnabled = true
  }
  
}

// MARK: - Configure current forecast
extension ForecastView {

  func configure(by viewModel: ContentViewModel) {
    iconLabel.attributedText = viewModel.icon
    dateLabel.text = viewModel.weekdayMonthDay
    cityNameLabel.text = viewModel.cityName
    temperatureLabel.text = viewModel.temperature
    
    windView.configure(condition: .strongWind, value: viewModel.windSpeed)
    humidityView.configure(condition: .humidity, value: viewModel.humidity)
    sunriseView.configure(condition: .sunrise, value: viewModel.sunriseTime)
    sunsetView.configure(condition: .sunset, value: viewModel.sunsetTime)
    
    iconLabel.alpha = 1
    dateLabel.alpha = 1
    cityNameLabel.alpha = 1
    temperatureLabel.alpha = 1
    windView.alpha = 1
    humidityView.alpha = 1
    sunriseView.alpha = 1
    sunsetView.alpha = 1
    
    viewModels = viewModel.hourly?.data.compactMap { DefaultHourlyForecastCellViewModel(hourlyData: $0) }
    hourlyCollectionView.reloadData()
    moreDetailsView.alpha = 1
  }

}

// MARK: - Animate labels
extension ForecastView {
  
  func animateLabelsScaling() {
    if UIScreen.PhoneModel.isPhoneSE {
      iconLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      dateLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      
    } else if UIScreen.PhoneModel.isPhone8 {
      iconLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      dateLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
      
    } else {
      iconLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
      dateLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
      cityNameLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
      temperatureLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
    }
  }
  
  func animateLabelsIdentity() {
    iconLabel.transform = .identity
    dateLabel.transform = .identity
    cityNameLabel.transform = .identity
    temperatureLabel.transform = .identity
  }
  
}

// MARK: - UICollectionViewDataSource protocol
extension ForecastView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? HourlyCollectionViewCell,
      let item = viewModels?[safe: indexPath.item] else { return UICollectionViewCell()
    }
  
    cell.configure(by: item)
    return cell
  }
  
}

// MARK: UICollectionViewDelegateFlowLayout protocol
extension ForecastView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 85)
  }
  
}

// MARK: - Action
extension ForecastView {
  
  @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
    viewDidExpand = !viewDidExpand
    
    if viewDidExpand {
      delegate?.currentForecastDidExpand()
      
    } else {
      delegate?.currentForecastDidCollapse()
    }
  }
  
}
