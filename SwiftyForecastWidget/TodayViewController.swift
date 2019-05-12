import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var conditionSummaryLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var temperatureMaxMinLabel: UILabel!
  @IBOutlet private weak var hourlyCollectionView: UICollectionView!
  
  typealias WidgetStyle = Style.WeatherWidget
  
  private var forecast: WeatherForecast?
  private var currentForecast: CurrentForecast?
  private var currentDayDetails: DailyData?
  private var hourlyForecast: HourlyForecast?

  private lazy var tapGesture: UITapGestureRecognizer = {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchHostingApp))
    gestureRecognizer.numberOfTouchesRequired = 1
    gestureRecognizer.numberOfTapsRequired = 1
    return gestureRecognizer
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    setUpStyle()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchWeatherForecast { error in
      if error == nil {
        self.configure()
        self.updateHourlyForecast()
      }
    }
  }
}

// MARK: - NCWidgetProviding protocol
extension TodayViewController: ViewSetupable {
  
  func setUp() {
    setCollectionView()
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    view.addGestureRecognizer(tapGesture)
  }
  
  func setUpStyle() {
    iconLabel.textColor = WidgetStyle.iconLabelTextColor
    
    cityNameLabel.font = WidgetStyle.cityNameLabelFont
    cityNameLabel.textColor = WidgetStyle.cityNameLabelTextColor
    cityNameLabel.textAlignment = WidgetStyle.cityNameLabelTextAlignment
    cityNameLabel.numberOfLines = WidgetStyle.cityNameLabelNumberOfLines
    
    conditionSummaryLabel.font = WidgetStyle.conditionSummaryLabelFont
    conditionSummaryLabel.textColor = WidgetStyle.conditionSummaryLabelTextColor
    conditionSummaryLabel.textAlignment = WidgetStyle.conditionSummaryLabelTextAlignment
    conditionSummaryLabel.numberOfLines = WidgetStyle.conditionSummaryLabelNumberOfLines
    
    humidityLabel.font = WidgetStyle.humidityLabelFont
    humidityLabel.textColor = WidgetStyle.humidityLabelTextColor
    humidityLabel.textAlignment = WidgetStyle.humidityLabelTextAlignment
    humidityLabel.numberOfLines = WidgetStyle.humidityLabelNumberOfLines
    
    temperatureLabel.font = WidgetStyle.temperatureLabelFont
    temperatureLabel.textColor = WidgetStyle.temperatureLabelTextColor
    temperatureLabel.textAlignment = WidgetStyle.temperatureLabelTextAlignment
    temperatureLabel.numberOfLines = WidgetStyle.temperatureLabelNumberOfLines
    
    temperatureMaxMinLabel.font = WidgetStyle.temperatureMaxMinLabelFont
    temperatureMaxMinLabel.textColor = WidgetStyle.temperatureMaxMinLabelTextColor
    temperatureMaxMinLabel.textAlignment = WidgetStyle.temperatureMaxMinLabelTextAlignment
    temperatureMaxMinLabel.numberOfLines = WidgetStyle.temperatureMaxMinLabelNumberOfLines
    
    hideLabels()
  }
  
}

// MARK: - Set collection view
private extension TodayViewController {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyForecastCollectionViewCell.self)
    hourlyCollectionView.dataSource = self
    hourlyCollectionView.delegate = self
    hourlyCollectionView.alwaysBounceHorizontal = false
    hourlyCollectionView.alwaysBounceVertical = false
    hourlyCollectionView.showsVerticalScrollIndicator = false
    hourlyCollectionView.showsHorizontalScrollIndicator = false
    hourlyCollectionView.backgroundColor = .clear
  }
  
}

// MARK: - Configure current forecast
private extension TodayViewController {

  func fetchWeatherForecast(completionHandler: @escaping (_ error: Error?)->()) {
    guard let currentCity = SharedGroupContainer.getSharedCity() else { return }
    
    let request = ForecastRequest.make(by: (currentCity.latitude, currentCity.longitude))
    WebServiceManager.shared.fetch(ForecastResponse.self, with: request, completionHandler: { [weak self] response in
      guard let strongSelf = self else { return }
      
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          let weatherForecast = WeatherForecast(city: currentCity, forecastResponse: forecast)
          strongSelf.forecast = weatherForecast
          strongSelf.currentDayDetails = weatherForecast.daily.currentDayData
          completionHandler(nil)
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          completionHandler(error)
        }
      }
    })
  }
  
  func configure() {
    if let forecast = forecast, let details = currentDayDetails  {
      hourlyForecast = forecast.hourly
      
      let fontSize = WidgetStyle.iconLabelFontSize
      let icon = ConditionFontIcon.make(icon: forecast.currently.icon, font: fontSize)
      iconLabel.attributedText = icon?.attributedIcon
      cityNameLabel.text = forecast.city.name
      temperatureLabel.text = forecast.currently.temperatureFormatted
      conditionSummaryLabel.text = details.summary
      humidityLabel.text = "Humidity: \(Int(details.humidity * 100)) %"
      temperatureMaxMinLabel.text = "\(details.temperatureMinFormatted) / \(details.temperatureMaxFormatted)"
      
      iconLabel.alpha = 1
      cityNameLabel.alpha = 1
      conditionSummaryLabel.alpha = 1
      humidityLabel.alpha = 1
      temperatureLabel.alpha = 1
      temperatureMaxMinLabel.alpha = 1

    } else {
      hideLabels()
    }
  }
  
  func hideLabels() {
    iconLabel.alpha = 0
    cityNameLabel.alpha = 0
    conditionSummaryLabel.alpha = 0
    humidityLabel.alpha = 0
    temperatureLabel.alpha = 0
    temperatureMaxMinLabel.alpha = 0
  }
}

// MARK: - Private - Actions
private extension TodayViewController {
  
  @objc func launchHostingApp(_ sender: AnyObject) {
    guard let hostApplicationUrl = URL(string: "host-screen:") else { return }
    extensionContext?.open(hostApplicationUrl) { success in
      if (!success) {
        print("error: failed to open host app from Today Extension")
      }
    }
  }

  func updateHourlyForecast() {
    hourlyCollectionView.reloadData()
  }
}

// MARK: - NCWidgetProviding protocol
extension TodayViewController: NCWidgetProviding {
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    fetchWeatherForecast { error in
      if error == nil {
        self.configure()
        self.updateHourlyForecast()
        completionHandler(.newData)
        
      } else {
        completionHandler(.failed)
      }
    }
    
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return .zero
  }
  
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
                                        withMaximumSize maxSize: CGSize) {
    let expanded = activeDisplayMode == .expanded
    preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
  }
  
}

// MARK - CollectionViewDataSource delegate
extension TodayViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    let eightHoursForecast = 8
    return eightHoursForecast
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.reuseIdentifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
    
    guard let item = hourlyForecast?.data[indexPath.item] else { return UICollectionViewCell() }
    
    cell.configure(by: DefaultHourlyForecastCellViewModel(hourlyData: item))
    return cell
  }
}

// MARK: UICollectionViewDelegateFlowLayout protocol
extension TodayViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 85)
  }
  
}
