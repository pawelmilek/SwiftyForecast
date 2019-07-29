import UIKit
import CoreData

class ForecastContentViewController: UIViewController {
  @IBOutlet private weak var currentForecastView: CurrentForecastView!
  @IBOutlet private weak var weekTableView: UITableView!
  
  var currentCityFetchedFromPlaces: City?
  var pageIndex = 0
  
  private let service = DefaultForecastService()
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var currentForecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  private var viewModel: CurrentForecastViewModel?
  private var isCurrentLocationPage: Bool {
    return pageIndex == 0
  }
  
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
    dailyForecastTableViewBottomConstraint = currentForecastView.bottomAnchor.constraint(equalTo: self.weekTableView.bottomAnchor,
                                                                                         constant: 0)
  }
  
}

// MARK: - Private - Set daily Forecast TableView
private extension ForecastContentViewController {
  
  func setDailyForecastTableView() {
    weekTableView.register(cellClass: DailyForecastTableViewCell.self)
    weekTableView.dataSource = self
    weekTableView.delegate = self
    weekTableView.showsVerticalScrollIndicator = false
    weekTableView.allowsSelection = false
    weekTableView.rowHeight = UITableView.automaticDimension
    weekTableView.estimatedRowHeight = 85
    weekTableView.backgroundColor = Style.ForecastContentVC.tableViewBackgroundColor
    weekTableView.separatorStyle = Style.ForecastContentVC.tableViewSeparatorStyle
    weekTableView.tableFooterView = UIView()
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
    if isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled {
      fetchForecastForCurrentLocation()
      
    } else if let currentCity = currentCityFetchedFromPlaces {
      fetchWeatherForecast(for: currentCity)
    }
  }
  
  func fetchForecastForCurrentLocation() {
    ActivityIndicatorView.shared.startAnimating(at: view)
    GeocoderHelper.currentPlace() { [weak self] result in
      guard let strongSelf = self else { return }
      
      switch result {
      case .success(let data):
        let city = City(place: data)
        strongSelf.currentCityFetchedFromPlaces = city
        strongSelf.viewModel = DefaultCurrentForecastViewModel(city: city, service: strongSelf.service, delegate: self)
        
      case .failure(let error):
        ActivityIndicatorView.shared.stopAnimating()
        error == .locationDisabled
          ? LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
          : error.handler()
      }
      
    }
  }
  
  func fetchWeatherForecast(for city: City) {
    ActivityIndicatorView.shared.startAnimating(at: view)
    viewModel = DefaultCurrentForecastViewModel(city: city, service: service, delegate: self)
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
    return viewModel?.numberOfDays ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dailyItems = viewModel?.sevenDaysData else { return UITableViewCell() }
    
    let item = dailyItems[indexPath.row]
    let viewModel = DefaultDailyForecastCellViewModel(dailyData: item)
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
  
  @objc func unitNotationDidChange(_ notification: NSNotification) {
    guard let segmentedControl = notification.userInfo?["SegmentedControl"] as? SegmentedControl else { return }
    NotationSystem.selectedUnitNotation = (segmentedControl.selectedIndex == 0 ? .imperial : .metric)
    reloadForecast()
  }
  
  @objc func locationServiceDidBecomeEnable(_ notification: NSNotification) {
    fetchForecastForCurrentLocation()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    fetchWeatherForecast()
  }
  
  private func reloadForecast() {
    guard let viewModel = viewModel else { return }
    
    DispatchQueue.main.async { [weak self] in
      self?.currentForecastView.configure(by: viewModel)
      self?.weekTableView.reloadData()
    }
  }
  
}

// MARK: - CurrentForecastViewModelDelegate protocol
extension ForecastContentViewController: CurrentForecastViewModelDelegate {
  
  func currentForecastViewModelDidFetchData(_ viewModel: CurrentForecastViewModel, error: WebServiceError?) {
    guard error == nil else {
      DispatchQueue.main.async {
        ActivityIndicatorView.shared.stopAnimating()
        error?.handler()
      }
      return
    }
    
    if let city = currentCityFetchedFromPlaces, isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled {
      // COREDATA!!
      if city.isExists() == false {
        LocalizedCityManager.deleteCurrentCity()
        LocalizedCityManager.insertCurrent(city: city)
        
        self.reloadAndInitializeMainPageViewController()
        CoreDataStackHelper.shared.saveContext()
        
      } else {
        LocalizedCityManager.fetchAndResetCities()
        LocalizedCityManager.updateCurrent(city: city)
        self.reloadDataInMainPageViewController()
      }
      
      SharedGroupContainer.sharedCity = city
    }
    
    DispatchQueue.main.async {
      ActivityIndicatorView.shared.stopAnimating()
    }
    reloadForecast()
  }
  
}
