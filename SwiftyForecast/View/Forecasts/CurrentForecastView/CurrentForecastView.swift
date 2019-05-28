import UIKit

final class CurrentForecastView: UIView {
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
    imageView.image = UIImage(named: "swifty_background")
    imageView.layer.masksToBounds = true
    imageView.frame = contentView.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return imageView
  }()
  
  private var viewDidExpand = false
  private var hourly: HourlyForecast?
  weak var delegate: CurrentForecastViewDelegate?
  
  typealias ForecastStyle = Style.CurrentForecast
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    setUpStyle()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
    setUpStyle()
  }
}

// MARK: ViewSetupable protocol
extension CurrentForecastView: ViewSetupable {
  
  func setUp() {
    loadAndAddSubviews()
    setShadowForBaseView()
    setRoundedCornersForContentView()
    setCollectionView()
    addTapGestureRecognizer()
    
    configure(by: .none)
  }
  
  func setUpStyle() {
    iconLabel.textColor = ForecastStyle.textColor
    iconLabel.textAlignment = ForecastStyle.textAlignment
    
    dateLabel.font = ForecastStyle.dateLabelFont
    dateLabel.textColor = ForecastStyle.textColor
    dateLabel.textAlignment = ForecastStyle.textAlignment
    
    cityNameLabel.font = ForecastStyle.cityNameLabelFont
    cityNameLabel.textColor = ForecastStyle.textColor
    cityNameLabel.textAlignment = ForecastStyle.textAlignment
    
    temperatureLabel.font = ForecastStyle.temperatureLabelFont
    temperatureLabel.textColor = ForecastStyle.textColor
    temperatureLabel.textAlignment = ForecastStyle.textAlignment
    
    moreDetailsView.backgroundColor = ForecastStyle.backgroundColor
    hourlyCollectionView.backgroundColor = ForecastStyle.backgroundColor
  }
  
}

// MARK: - Set bottom shadow
private extension CurrentForecastView {
  
  func loadAndAddSubviews() {
    let nibName = CurrentForecastView.nibName
    Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
    
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    contentView.addSubview(backgroundImageView)
    contentView.sendSubviewToBack(backgroundImageView)
  }
  
}

// MARK: - Set bottom shadow
private extension CurrentForecastView {
  
  func setShadowForBaseView() {
    backgroundColor = ForecastStyle.backgroundColor
    layer.shadowColor = ForecastStyle.shadowColor
    layer.shadowOffset = ForecastStyle.shadowOffset
    layer.shadowOpacity = ForecastStyle.shadowOpacity
    layer.shadowRadius = ForecastStyle.shadowRadius
    layer.masksToBounds = false
  }
  
  func setRoundedCornersForContentView() {
    contentView.layer.cornerRadius = ForecastStyle.cornerRadius
    contentView.layer.masksToBounds = true
  }
}

// MARK: - Set collection view
private extension CurrentForecastView {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyCollectionViewCell.self)
    hourlyCollectionView.dataSource = self
    hourlyCollectionView.delegate = self
    hourlyCollectionView.showsVerticalScrollIndicator = false
    hourlyCollectionView.showsHorizontalScrollIndicator = false
  }
  
}

// MARK: - Private - Add tap gesture recognizer
private extension CurrentForecastView {
  
  func addTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler(_:)))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    
    addGestureRecognizer(tapGestureRecognizer)
    isUserInteractionEnabled = true
  }
  
}

// MARK: - Configure current forecast
extension CurrentForecastView {
  
  func configure(by viewModel: CurrentForecastViewModel) {
    
  }
  
  func configure(by viewModel: CurrentForecastViewModel?) {
    guard let viewModel = viewModel else {
      temperatureLabel.alpha = 0
      iconLabel.alpha = 0
      dateLabel.alpha = 0
      cityNameLabel.alpha = 0
      windView.alpha = 0
      humidityView.alpha = 0
      sunriseView.alpha = 0
      sunsetView.alpha = 0
      moreDetailsView.alpha = 0
      return
    }
    
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
    
    hourly = viewModel.hourly
    hourlyCollectionView.reloadData()
    moreDetailsView.alpha = 1
  }

}

// MARK: - Animate labels
extension CurrentForecastView {
  
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
extension CurrentForecastView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourly?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? HourlyCollectionViewCell,
          let item = hourly?.data[indexPath.item] else { return UICollectionViewCell()
            
    }
    let viewModel = DefaultHourlyForecastCellViewModel(hourlyData: item)
    cell.configure(by: viewModel)
    return cell
  }
  
}

// MARK: UICollectionViewDelegateFlowLayout protocol
extension CurrentForecastView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 85)
  }
  
}

// MARK: - Action
extension CurrentForecastView {
  
  @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
    viewDidExpand = !viewDidExpand
    
    if viewDidExpand {
      delegate?.currentForecastDidExpandAnimation()
      
    } else {
      delegate?.currentForecastDidCollapseAnimation()
    }
  }
  
}
