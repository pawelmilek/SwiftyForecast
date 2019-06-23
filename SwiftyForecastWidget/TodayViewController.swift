import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var conditionSummaryLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var temperatureMinMaxLabel: UILabel!
  @IBOutlet private weak var hourlyCollectionView: UICollectionView!
  
  private var forecast: WeatherForecast?
  private var currentForecast: CurrentForecast?
  private var todayViewModel: TodayForecastViewModel?
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
    iconLabel.textColor = Style.WeatherWidget.iconLabelTextColor
    
    cityNameLabel.font = Style.WeatherWidget.cityNameLabelFont
    cityNameLabel.textColor = Style.WeatherWidget.cityNameLabelTextColor
    cityNameLabel.textAlignment = Style.WeatherWidget.cityNameLabelTextAlignment
    cityNameLabel.numberOfLines = Style.WeatherWidget.cityNameLabelNumberOfLines
    
    conditionSummaryLabel.font = Style.WeatherWidget.conditionSummaryLabelFont
    conditionSummaryLabel.textColor = Style.WeatherWidget.conditionSummaryLabelTextColor
    conditionSummaryLabel.textAlignment = Style.WeatherWidget.conditionSummaryLabelTextAlignment
    conditionSummaryLabel.numberOfLines = Style.WeatherWidget.conditionSummaryLabelNumberOfLines
    
    humidityLabel.font = Style.WeatherWidget.humidityLabelFont
    humidityLabel.textColor = Style.WeatherWidget.humidityLabelTextColor
    humidityLabel.textAlignment = Style.WeatherWidget.humidityLabelTextAlignment
    humidityLabel.numberOfLines = Style.WeatherWidget.humidityLabelNumberOfLines
    
    temperatureLabel.font = Style.WeatherWidget.temperatureLabelFont
    temperatureLabel.textColor = Style.WeatherWidget.temperatureLabelTextColor
    temperatureLabel.textAlignment = Style.WeatherWidget.temperatureLabelTextAlignment
    temperatureLabel.numberOfLines = Style.WeatherWidget.temperatureLabelNumberOfLines
    
    temperatureMinMaxLabel.font = Style.WeatherWidget.temperatureMaxMinLabelFont
    temperatureMinMaxLabel.textColor = Style.WeatherWidget.temperatureMaxMinLabelTextColor
    temperatureMinMaxLabel.textAlignment = Style.WeatherWidget.temperatureMaxMinLabelTextAlignment
    temperatureMinMaxLabel.numberOfLines = Style.WeatherWidget.temperatureMaxMinLabelNumberOfLines
    
    hideLabels()
  }
  
}

// MARK: - Set collection view
private extension TodayViewController {
  
  func setCollectionView() {
    hourlyCollectionView.register(cellClass: HourlyCollectionViewCell.self)
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
  
  // TODO: Implement DefaultForecastService
  func fetchWeatherForecast(completionHandler: @escaping (_ error: Error?)->()) {
    guard let currentCity = SharedGroupContainer.getSharedCity() else { return }
    
    let request = ForecastRequest.make(by: (currentCity.latitude, currentCity.longitude))
    WebServiceRequest.fetch(ForecastResponse.self, with: request, completionHandler: { [weak self] response in
      guard let strongSelf = self else { return }
      
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          let weatherForecast = WeatherForecast(city: currentCity, forecastResponse: forecast)
          strongSelf.forecast = weatherForecast
          strongSelf.todayViewModel = DefaultTodayForecastViewModel(dailyData: weatherForecast.daily.currentDayData!)
          completionHandler(nil)
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          completionHandler(error)
        }
      }
    })
  }
  
  func configure() { // TODO: Implement ViewModel
    if let forecast = forecast, let todayViewModel = todayViewModel  {
      hourlyForecast = forecast.hourly
      
      cityNameLabel.text = forecast.city.name
      temperatureLabel.text = forecast.currently.temperatureFormatted
      
      iconLabel.attributedText = todayViewModel.icon
      conditionSummaryLabel.text = todayViewModel.summary
      humidityLabel.text = todayViewModel.humidity
      temperatureMinMaxLabel.text = todayViewModel.temperatureMinMax
      
      iconLabel.alpha = 1
      cityNameLabel.alpha = 1
      conditionSummaryLabel.alpha = 1
      humidityLabel.alpha = 1
      temperatureLabel.alpha = 1
      temperatureMinMaxLabel.alpha = 1
      
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
    temperatureMinMaxLabel.alpha = 0
  }
}

// MARK: - Private - Actions
private extension TodayViewController {
  
  @objc func launchHostingApp(_ sender: AnyObject) {
    guard let hostApplicationUrl = URL(string: "host-screen:") else { return }
    extensionContext?.open(hostApplicationUrl) { success in
      if (!success) {
        debugPrint("error: failed to open host app from Today Extension")
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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
    guard let item = hourlyForecast?.data[indexPath.item] else { return UICollectionViewCell() }
    
    let viewModel = DefaultHourlyForecastCellViewModel(hourlyData: item)
    cell.configure(by: viewModel)
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
