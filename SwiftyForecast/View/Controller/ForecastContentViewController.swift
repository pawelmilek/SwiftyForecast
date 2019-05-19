import UIKit
import CoreData

class ForecastContentViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var dailyForecastTableView: UITableView!
  
  typealias ForecastContentStyle = Style.ForecastContentVC
  private let sharedStack = CoreDataStackHelper.shared
  private let sharedActivityIndicator = ActivityIndicatorView.shared
  private let sharedLocationProvider = LocationProvider.shared
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  private var isFeatchingForecast = false
//  private var viewModel: DailyDataViewModel?
  
  var currentCityForecast: City?
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast,
            let currentDayDetails = weatherForecast.daily.currentDayData else { return }
      currentForecastView.configure(current: weatherForecast.currently,
                                    currentDayDetails: currentDayDetails,
                                    at: weatherForecast.city)
      currentForecastView.configure(hourly: weatherForecast.hourly)
      dailyForecastTableView.reloadData()
    }
  }
  
  var pageIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchWeatherForecast()
  }
  
  deinit {
    removeNotificationCenterObservers()
  }
}

// MARK: - ViewSetupable protocol
extension ForecastContentViewController: ViewSetupable {
  
  func setUp() {
    setCurrentForecastViewDelegate()
    setSupportingCurrentForecastViewConstraints()
    setDailyForecastTableView()
    addNotificationCenterObservers()
  }
  
}

// MARK: - Private - Set currentForecastView delegate
private extension ForecastContentViewController {
  
  func setCurrentForecastViewDelegate() {
    currentForecastView.delegate = self
  }
  
}

// MARK: - Private - Set currentForecastView constraints
private extension ForecastContentViewController {
  
  func setSupportingCurrentForecastViewConstraints() {
    currentForecastViewMoreDetailsViewBottomConstraint = currentForecastView.moreDetailsViewBottomConstraint
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint = currentForecastView.stackViewBottomToMoreDetailsTopConstraint
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint = currentForecastView.stackViewBottomToSafeAreaBottomConstraint
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor, constant: 0)
  }
  
}

// MARK: - Private - Set daily Forecast TableView
private extension ForecastContentViewController {
  
  func setDailyForecastTableView() {
    dailyForecastTableView.register(cellClass: DailyForecastTableViewCell.self)
    dailyForecastTableView.dataSource = self
    dailyForecastTableView.delegate = self
    dailyForecastTableView.showsVerticalScrollIndicator = false
    dailyForecastTableView.allowsSelection = false
    dailyForecastTableView.rowHeight = UITableView.automaticDimension
    dailyForecastTableView.estimatedRowHeight = 85
    dailyForecastTableView.backgroundColor = ForecastContentStyle.tableViewBackgroundColor
    dailyForecastTableView.separatorStyle = ForecastContentStyle.tableViewSeparatorStyle
    dailyForecastTableView.tableFooterView = UIView()
  }
  
}

// MARK: - Private - Add notification center
private extension ForecastContentViewController {
  
  func addNotificationCenterObservers() {
    NotificationAdapter.add(observer: self, selector: #selector(measuringSystemDidSwitch), for: .measuringSystemDidSwitch)
    NotificationAdapter.add(observer: self, selector: #selector(locationServiceDidBecomeEnable), for: .locationServiceDidBecomeEnable)
    NotificationAdapter.add(observer: self, selector: #selector(applicationDidBecomeActive), for: .applicationDidBecomeActive)
  }
  
  func removeNotificationCenterObservers() {
    NotificationAdapter.remove(observer: self)
  }
  
}

// MAKR: - Private - Fetch weather forecast
private extension ForecastContentViewController {
  
  func fetchWeatherForecast() {
    guard !isFeatchingForecast else { return }
    
    var isCurrentLocationPage: Bool {
      return pageIndex == 0
    }
    
    if isCurrentLocationPage && sharedLocationProvider.isLocationServicesEnabled {
      fetchWeatherForecastForCurrentLocation()
  
    } else if let currentCityForecast = currentCityForecast {
      fetchWeatherForecast(for: currentCityForecast)
    }
  }
  
  func fetchWeatherForecastForCurrentLocation() {
    sharedActivityIndicator.startAnimating(at: view)
    isFeatchingForecast = true
    
    GooglePlacesHelper.getCurrentPlace() { [weak self] place, error in
      guard let strongSelf = self else { return }
      strongSelf.isFeatchingForecast = false
      
      if let error = error {
        strongSelf.sharedActivityIndicator.stopAnimating()
        error == .locationDisabled ? strongSelf.sharedLocationProvider.presentLocationServicesSettingsPopupAlert() : error.handle()
        return
      }
      
      if let place = place {
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude

        let request = ForecastRequest.make(by: (latitude, longitude))
        WebServiceManager.shared.fetch(ForecastResponse.self, with: request, completionHandler: { response in
          switch response {
          case .success(let forecast):
            DispatchQueue.main.async {
              let unassociatedCity = City(place: place)
              strongSelf.weatherForecast = WeatherForecast(city: unassociatedCity, forecastResponse: forecast)
              
              if unassociatedCity.isExists() == false {
                LocalizedCityManager.deleteCurrentLocalizedCity()
                LocalizedCityManager.insertCurrentLocalized(city: unassociatedCity)
                strongSelf.currentCityForecast = unassociatedCity
                strongSelf.reloadAndInitializeMainPageViewController()
                strongSelf.sharedStack.saveContext()
                
              } else {
                LocalizedCityManager.fetchAndResetLocalizedCities()
                LocalizedCityManager.updateCurrentLocalized(city: unassociatedCity)
                strongSelf.reloadDataInMainPageViewController()
              }
              
              SharedGroupContainer.setShared(city: unassociatedCity)
              strongSelf.sharedActivityIndicator.stopAnimating()
            }
            
          case .failure(let error):
            DispatchQueue.main.async {
              strongSelf.sharedActivityIndicator.stopAnimating()
              error.handle()
            }
          }
        })
        
      } else {
        strongSelf.sharedActivityIndicator.stopAnimating()
        GooglePlacesError.placeNotFound.handle()
      }
    }
  }
  
  
  func fetchWeatherForecast(for city: City) {
    sharedActivityIndicator.startAnimating(at: view)
    isFeatchingForecast = true
    
    let request = ForecastRequest.make(by: (city.latitude, city.longitude))
    WebServiceManager.shared.fetch(ForecastResponse.self, with: request, completionHandler: { [weak self] response in
      guard let strongSelf = self else { return }
      strongSelf.isFeatchingForecast = false
      
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          strongSelf.weatherForecast = WeatherForecast(city: city, forecastResponse: forecast)
          strongSelf.sharedActivityIndicator.stopAnimating()
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          strongSelf.sharedActivityIndicator.stopAnimating()
          error.handle()
        }
      }
    })
  }
  
}


// MARK: - Private - Check and decide when to fetch new forecast
private extension ForecastContentViewController {
  
  func checkAndDecideWhenToFetchNewForecast() -> Bool {
    let currentDate = Date()
    let cityLastUpdate = currentCityForecast?.lastUpdate ?? Date()
    
    let differenceInSeconds = Int(currentDate.timeIntervalSince(cityLastUpdate))
    let (hours, minutes, seconds) = differenceInSeconds.convertToHoursMinutesSeconds
    print((hours, minutes, seconds))
    
    if hours > 0 || minutes > 30 {
      return true
      
    } else {
      return false
    }
  }
  
}


// MARK: - Private - Reload pages
private extension ForecastContentViewController {
  
  func reloadAndInitializeMainPageViewController() {
    NotificationAdapter.post(.reloadPages)
  }
  
  func reloadDataInMainPageViewController() {
    NotificationAdapter.post(.reloadPagesData)
  }
  
}


// MARK: - CurrentForecastViewDelegate protocol
extension ForecastContentViewController: CurrentForecastViewDelegate {
  
  func currentForecastDidExpandAnimation() {
    animateBouncingEffect()
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = 0
    dailyForecastTableViewBottomConstraint?.isActive = true
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = false
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = true
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
      self.currentForecastView.animateLabelsScaling()
      self.view.layoutIfNeeded()
    })
  }
  
  func currentForecastDidCollapseAnimation() {
    let height = currentForecastView.frame.size.height
    
    currentForecastViewMoreDetailsViewBottomConstraint?.constant = height
    dailyForecastTableViewBottomConstraint?.isActive = false
    currentForecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = true
    currentForecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = false
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseIn,
                   animations: {
      self.currentForecastView.animateLabelsIdentity()
      self.view.layoutIfNeeded()
    })
  }
  
}


// MARK: - Private - Animate bouncing effect
private extension ForecastContentViewController {
  
  func animateBouncingEffect() {
    currentForecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 1.8,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 6.0,
                   options: .allowUserInteraction,
                   animations: {
      self.currentForecastView.transform = .identity
    })
  }
  
}

// MARK: - UITableViewDataSource protcol
extension ForecastContentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherForecast?.daily.numberOfDays ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dailyItems = weatherForecast?.daily.sevenDaysData else { return UITableViewCell() }
    
    let cell = tableView.dequeueCell(DailyForecastTableViewCell.self, for: indexPath)
    
    let dailyData = dailyItems[indexPath.row]
    let viewModel = DefaultDailyForecastCellViewModel(dailyData: dailyData)
    cell.configure(by: viewModel)
    return cell
  }
  
}


// MARK: - UITableViewDelegate protocol
extension ForecastContentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}


// MARK: - Actions
extension ForecastContentViewController {
  
  @objc func locationServiceDidBecomeEnable(_ notification: NSNotification) {
    fetchWeatherForecastForCurrentLocation()
  }
  
  
  @objc func measuringSystemDidSwitch(_ notification: NSNotification) {
    guard let segmentedControl = notification.userInfo?["SegmentedControl"] as? SegmentedControl else { return }
    MeasuringSystem.selected = (segmentedControl.selectedIndex == 0 ? .imperial : .metric)
    reloadForecast()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    fetchWeatherForecast() // TODO: Change it after implementing CoreData for WeatherForecast!
//    guard sharedLocationProvider.isLocationServicesEnabled else { return }
//    guard let previousLocation = sharedLocationProvider.currentLocation else { return }
//
//    sharedLocationProvider.requestLocation { [weak self] newLocation in
//      let minDistanceInMeters = 500.00
//      let didUserChangeHisLocation = previousLocation.distance(from: newLocation) >= minDistanceInMeters
//      if didUserChangeHisLocation {
//        self?.fetchWeatherForecast()
//      }
//    }
  }
  
  
  private func reloadForecast() {
    guard let previousWeatherForecast = weatherForecast else { return }
    weatherForecast = previousWeatherForecast
  }
  
}
