import UIKit
import CoreData

class ForecastContentViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var dailyForecastTableView: UITableView!
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  private var isFeatchingForecast = false
  
  private var viewModel: CurrentForecastViewModel?
  
  // TODO: The View/ViewController doesn't know about the Model. It intercacts with Model layer trough one or more ViewMdoels.
  var currentCityForecast: City?
  
  var weatherForecast: WeatherForecast? {
    didSet {
      guard let weatherForecast = weatherForecast else { return }
      
      let currentViewModel = DefaultCurrentForecastViewModel(weatherForecast: weatherForecast, service: DefaultForecastService())
      currentForecastView.configure(by: currentViewModel)
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
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.dailyForecastTableView.bottomAnchor,
                                                                                         constant: 0)
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
    dailyForecastTableView.backgroundColor = Style.ForecastContentVC.tableViewBackgroundColor
    dailyForecastTableView.separatorStyle = Style.ForecastContentVC.tableViewSeparatorStyle
    dailyForecastTableView.tableFooterView = UIView()
  }
  
}

// MARK: - Private - Add notification center
private extension ForecastContentViewController {
  
  func addNotificationCenterObservers() {
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(unitNotationDidChange),
                                   for: .unitNotationDidChange)
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(locationServiceDidBecomeEnable),
                                   for: .locationServiceDidBecomeEnable)
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(applicationDidBecomeActive),
                                   for: .applicationDidBecomeActive)
  }
  
  func removeNotificationCenterObservers() {
    ForecastNotificationCenter.remove(observer: self)
  }
  
}

// MAKR: - Private - Fetch weather forecast
private extension ForecastContentViewController {
  
  func fetchWeatherForecast() {
    guard !isFeatchingForecast else { return }
    
    var isCurrentLocationPage: Bool {
      return pageIndex == 0
    }
    
    if isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled {
      fetchWeatherForecastForCurrentLocation()
      
    } else if let currentCityForecast = currentCityForecast {
      fetchWeatherForecast(for: currentCityForecast)
    }
  }
  
  func fetchWeatherForecastForCurrentLocation() {
    ActivityIndicatorView.shared.startAnimating(at: view)
    isFeatchingForecast = true
    
    GooglePlacesHelper.getCurrentPlace() { [weak self] place, error in
      guard let strongSelf = self else { return }
      strongSelf.isFeatchingForecast = false
      
      if let error = error {
        ActivityIndicatorView.shared.stopAnimating()
        error == .locationDisabled ? LocationProvider.shared.presentLocationServicesSettingsPopupAlert() : error.handler()
        return
      }
      
      if let place = place {
        let coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let service = DefaultForecastService()
        service.getForecast(by: coordinate) { response in
          switch response {
          case .success(let forecast):
            DispatchQueue.main.async {
              let unassociatedCity = City(place: place)
              strongSelf.weatherForecast = WeatherForecast(city: unassociatedCity, forecastResponse: forecast)
              
              if unassociatedCity.isExists() == false {
                LocalizedCityManager.deleteCurrentCity()
                LocalizedCityManager.insertCurrent(city: unassociatedCity)
                strongSelf.currentCityForecast = unassociatedCity
                strongSelf.reloadAndInitializeMainPageViewController()
                CoreDataStackHelper.shared.saveContext()
                
              } else {
                LocalizedCityManager.fetchAndResetCities()
                LocalizedCityManager.updateCurrent(city: unassociatedCity)
                strongSelf.reloadDataInMainPageViewController()
              }
              
              SharedGroupContainer.setShared(city: unassociatedCity)
              ActivityIndicatorView.shared.stopAnimating()
            }
            
          case .failure(let error):
            DispatchQueue.main.async {
              ActivityIndicatorView.shared.stopAnimating()
              error.handler()
            }
          }
        }
        
      } else {
        ActivityIndicatorView.shared.stopAnimating()
        GooglePlacesError.placeNotFound.handler()
      }
    }
  }
  
  func fetchWeatherForecast(for city: City) {
    ActivityIndicatorView.shared.startAnimating(at: view)
    isFeatchingForecast = true
    
    let coordinate = Coordinate(latitude: city.latitude, longitude: city.longitude)
    let service = DefaultForecastService()
    
    service.getForecast(by: coordinate) { [weak self] response in
      guard let strongSelf = self else { return }
      strongSelf.isFeatchingForecast = false
      
      switch response {
      case .success(let forecast):
        DispatchQueue.main.async {
          strongSelf.weatherForecast = WeatherForecast(city: city, forecastResponse: forecast)
          ActivityIndicatorView.shared.stopAnimating()
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          ActivityIndicatorView.shared.stopAnimating()
          error.handler()
        }
      }
    }
  }
  
}

// MARK: - Private - Reload pages
private extension ForecastContentViewController {
  
  func reloadAndInitializeMainPageViewController() {
    ForecastNotificationCenter.post(.reloadPages)
  }
  
  func reloadDataInMainPageViewController() {
    ForecastNotificationCenter.post(.reloadPagesData)
  }
  
}

// MARK: - CurrentForecastViewDelegate protocol
extension ForecastContentViewController: CurrentForecastViewDelegate {
  
  func currentForecastDidExpand() {
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
  
  func currentForecastDidCollapse() {
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
    
    let dailyData = dailyItems[indexPath.row]
    let viewModel = DefaultDailyForecastCellViewModel(dailyData: dailyData)
    let cell = tableView.dequeueCell(DailyForecastTableViewCell.self, for: indexPath)
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
  
  @objc func unitNotationDidChange(_ notification: NSNotification) {
    guard let segmentedControl = notification.userInfo?["SegmentedControl"] as? SegmentedControl else { return }
    
    NotationSystem.selectedUnitNotation = (segmentedControl.selectedIndex == 0 ? .imperial : .metric)
    
    reloadForecast()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    fetchWeatherForecast()
  }
  
  private func reloadForecast() {
    guard let previousWeatherForecast = weatherForecast else { return }
    weatherForecast = previousWeatherForecast
  }
  
}

// MARK: - CurrentForecastViewModelDelegate protocol
extension ForecastContentViewController: CurrentForecastViewModelDelegate {
  
  func currentForecastViewModelDidFetchData(_ currentForecastViewModel: CurrentForecastViewModel) {
    
  }
  
}
