//
//  ForecastMainViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 11/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit

class ForecastMainViewController: UIViewController {
  @IBOutlet private weak var pageControl: UIPageControl!
  
  private let network = NetworkManager.shared
  
  private lazy var measuringSystemSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = ["\u{00B0}" + "F", "\u{00B0}" + "C"]
    segmentedControl.font = UIFont(name: "AvenirNext-Bold", size: 14)
    segmentedControl.borderWidth = 1.0
    segmentedControl.selectedLabelColor = .white
    segmentedControl.unselectedLabelColor = .blackShade
    segmentedControl.borderColor = .blackShade
    segmentedControl.thumbColor = .blackShade
    segmentedControl.selectedIndex = 0
    segmentedControl.backgroundColor = .clear
    segmentedControl.addTarget(self, action: #selector(measuringSystemSwitched(_:)), for: .valueChanged)
    return segmentedControl
  }()
  
  private lazy var pageViewController: UIPageViewController = {
    let storyboard = UIStoryboard(storyboard: .main)
    let pageVC = storyboard.instantiateViewController(UIPageViewController.self)
    pageVC.dataSource = self
    pageVC.delegate = self
    
    let forecastContentVC = forecastContentViewController(at: 0)!
    pageVC.setViewControllers([forecastContentVC], direction: .forward, animated: true)
    return pageVC
  }()
  
  private var cities: [City] = [] {
    didSet {
      pendingIndex = 0
      currentIndex = 0
    }
  }

  private var pendingIndex: Int?
  private var currentIndex = 0 {
    didSet {
      pageControl.currentPage = currentIndex
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showOrHideEnableLocationServicesPrompt()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.showCityListSegue.rawValue else { return }
    guard let cityListVC = segue.destination as? ForecastCityListTableViewController else { return }
    
    cityListVC.delegate = self
  }
  
  deinit {
    removeNotificationCenterObserver()
    CoreDataStackHelper.shared.mainContext.reset()
  }
}


// MARK: - ViewSetupable protocol
extension ForecastMainViewController: ViewSetupable {
  
  func setup() {
    fetchCities()
    initializePageViewController()
    setMetricSystemSegmentedControl()
    addNotificationCenterObserver()
    setNetworkManagerWhenInternetIsNotAvailable()
    setPageControl()
  }
  
  func setupLayout() {
    view.bringSubview(toFront: pageControl)
  }
  
}


// MARK: - Private - fetch cities
private extension ForecastMainViewController {
  
  func fetchCities() {
    let fetchRequest = City.createFetchRequest()
    let currentLocalizedSort = NSSortDescriptor(key: "isCurrentLocalized", ascending: false)
    fetchRequest.sortDescriptors = [currentLocalizedSort]
    
    do {
      cities = try CoreDataStackHelper.shared.mainContext.fetch(fetchRequest)
    } catch {
      CoreDataError.couldNotFetch.handle()
    }
  }
  
}


// MARK: - Private - Initialize PageViewController
private extension ForecastMainViewController {
  
  func initializePageViewController() {
    addChildViewController(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMove(toParentViewController: self)
  }
  
}


// MARK: - Private - Set metric system segmented control
private extension ForecastMainViewController {
  
  func setMetricSystemSegmentedControl() {
    navigationItem.titleView = measuringSystemSegmentedControl
  }
  
}


// MARK: - Private - NotificationCenter
private extension ForecastMainViewController {
  
  func addNotificationCenterObserver() {
    let reloadPagesName = NotificationCenterKey.reloadPagesNotification.name
    NotificationCenter.default.addObserver(self, selector: #selector(reloadPages(_:)), name: reloadPagesName, object: nil)
  }
  
  func removeNotificationCenterObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
}


// MARK: - Private - Set page control
private extension ForecastMainViewController {
  
  func setPageControl() {
    pageControl.currentPage = currentIndex
    pageControl.numberOfPages = cities.count
  }
  
}


// MARK: - Private - Set NetworkManager when internet is not available
private extension ForecastMainViewController {
  
  func setNetworkManagerWhenInternetIsNotAvailable() {
    let whenNetworkIsNotAvailable: () -> () = {
      let offlineViewController = OfflineViewController()
      self.navigationController?.pushViewController(offlineViewController, animated: false)
    }
    
    // Will run only once when app is launching
    network.isUnreachable { _ in
      whenNetworkIsNotAvailable()
    }
    
    // Network listener to pick up network changes in real-time
    network.whenUnreachable { _ in
      whenNetworkIsNotAvailable()
    }
  }
  
}


// MARK: - Private - Show or hide navigation prompt
private extension ForecastMainViewController {
  
  func showOrHideEnableLocationServicesPrompt() {
    let delayInSeconds = 2.0
    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
      guard let strongSelf = self else { return }
      
      if LocationProvider.shared.isLocationServicesEnabled {
        strongSelf.navigationItem.prompt = nil
        
      } else {
        strongSelf.navigationItem.prompt = NSLocalizedString("Please enable location services!", comment: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds + 3) { [weak self] in
          guard let strongSelf = self else { return }
          strongSelf.navigationItem.prompt = nil
          strongSelf.navigationController?.viewIfLoaded?.setNeedsLayout()
        }
      }
      
      strongSelf.navigationController?.viewIfLoaded?.setNeedsLayout()
    }

  }
  
}


// MARK: - Actions
extension ForecastMainViewController {
  
  @objc func reloadPages(_ notification: NSNotification) {
    fetchCities()
    setInitialViewController()
    setPageControl()
  }
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    let notificationName = NotificationCenterKey.measuringSystemDidSwitchNotification.name
    
    let segmentedControlData: [String: SegmentedControl] = ["SegmentedControl": sender]
    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: segmentedControlData)
  }
  
  @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
    let notificationName = NotificationCenterKey.refreshButtonDidPressNotification.name
    NotificationCenter.default.post(name: notificationName, object: nil)
  }
  
}


// MARK: - CityListTableViewControllerDelegate protocol
extension ForecastMainViewController: CityListTableViewControllerDelegate {
  
  func cityListController(_ cityListTableViewController: ForecastCityListTableViewController, didSelect city: City) {
    guard let newPageIndex = cities.index(of: city) else { return }
    moveToPage(at: newPageIndex) {
      self.currentIndex = newPageIndex
      self.pendingIndex = nil
    }
  }
  
}


// MARK: - Private - Move to page at index
private extension ForecastMainViewController {
  
  func moveToPage(at index: Int, completion: (() -> ())? = nil) {
    guard let vc = forecastContentViewController(at: index) else { return }
    guard index < cities.count else { return }
    
    if index > currentIndex {
      pageViewController.setViewControllers([vc], direction: .forward, animated: false) { complete in
        completion?()
      }
      
    } else if index < currentIndex {
      pageViewController.setViewControllers([vc], direction: .reverse, animated: false) { complete in
        completion?()
      }
    }
  }
  
}


// MARK: - Private - Set dataSource and first ViewController
private extension ForecastMainViewController {

  func setInitialViewController(at index: Int = 0) {
    guard let forecastContentVC = forecastContentViewController(at: index) else { return }
    pageViewController.setViewControllers([forecastContentVC], direction: .forward, animated: true)
  }

}


// MARK: - Private - Get ForecastPageViewController
private extension ForecastMainViewController {
  
  func forecastContentViewController(at index: Int) -> ForecastContentViewController? {
    let storyboard = UIStoryboard(storyboard: .main)
    let forecastVC = storyboard.instantiateViewController(ForecastContentViewController.self)
    forecastVC.pageIndex = index
    forecastVC.currentCityForecast = cities.isEmpty == true ? nil : cities[index]
    
    return forecastVC
  }
  
  func index(of forecastContentViewController: ForecastContentViewController) -> Int {
    guard let city = forecastContentViewController.currentCityForecast else { return NSNotFound }
    return cities.index(of: city) ?? NSNotFound
  }
  
}


// MARK: - UIPageViewControllerDataSource protocol
extension ForecastMainViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let forecastPageContentViewController = viewController as? ForecastContentViewController else { return nil }
    
    let indexOfViewController = index(of: forecastPageContentViewController)
    if indexOfViewController == NSNotFound || indexOfViewController == 0 {
      return nil
    }

    return forecastContentViewController(at: indexOfViewController - 1)
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let forecastPageContentViewController = viewController as? ForecastContentViewController else { return nil }
    
    let indexOfViewController = index(of: forecastPageContentViewController)
    if indexOfViewController == NSNotFound || (indexOfViewController + 1) == cities.count {
      return nil
    }

    return forecastContentViewController(at: indexOfViewController + 1)
  }
  
}


// MARK: - UIPageViewControllerDelegate protocol
extension ForecastMainViewController: UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let forecastContentViewController = pendingViewControllers.first as? ForecastContentViewController else { return }
    pendingIndex = forecastContentViewController.pageIndex
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard completed else { return }
    
    if let currentPageIndex = pendingIndex {
      currentIndex = currentPageIndex
    }
  }
  
}
