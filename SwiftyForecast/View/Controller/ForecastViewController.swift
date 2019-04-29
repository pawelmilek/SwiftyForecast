import UIKit
import CoreData
import SafariServices

class ForecastViewController: UIViewController {
  @IBOutlet private weak var pageControl: UIPageControl!
  
  typealias ForecastMainStyle = Style.ForecastMainVC
  
  private let network = NetworkManager.shared
  private lazy var stack: CoreDataStackHelper = CoreDataStackHelper.shared
  
  private lazy var measuringSystemSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = ["\u{00B0}" + "F", "\u{00B0}" + "C"]
    segmentedControl.font = ForecastMainStyle.measuringSystemSegmentedControlFont
    segmentedControl.borderWidth = ForecastMainStyle.measuringSystemSegmentedControlBorderWidth
    segmentedControl.selectedLabelColor = ForecastMainStyle.measuringSystemSegmentedControlSelectedLabelColor
    segmentedControl.unselectedLabelColor = ForecastMainStyle.measuringSystemSegmentedControlUnselectedLabelColor
    segmentedControl.borderColor = ForecastMainStyle.measuringSystemSegmentedControlBorderColor
    segmentedControl.thumbColor = ForecastMainStyle.measuringSystemSegmentedControlThumbColor
    segmentedControl.backgroundColor = ForecastMainStyle.measuringSystemSegmentedControlBackgroundColor
    segmentedControl.selectedIndex = 0
    
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
  
  private lazy var cities: NSFetchedResultsController<City> = {
    let context = CoreDataStackHelper.shared.managedContext
    let request = City.createFetchRequest()
    let currentLocalizedSort = NSSortDescriptor(key: "isCurrentLocalization", ascending: false)
    request.sortDescriptors = [currentLocalizedSort]
    
    let cities = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return cities
  }()
  
  private var cityCount: Int {
    return cities.fetchedObjects?.count ?? 0
  }
  
  private var contentViewiewControllers: [ForecastContentViewController] = []
  private var pendingIndex: Int?
  private var currentIndex = 0 {
    didSet {
      pageControl.currentPage = currentIndex
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    setupLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showOrHideEnableLocationServicesPrompt()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.showCityListSegue.rawValue else { return }
    guard let cityListVC = segue.destination as? ForecastCityTableViewController else { return }
    
    cityListVC.delegate = self
    cityListVC.managedObjectContext = stack.managedContext
  }
  
  deinit {
    removeNotificationCenterObserver()
  }
}


// MARK: - ViewSetupable protocol
extension ForecastViewController: ViewSetupable {
  
  func setUp() {
    fetchCitiesAndSetLastUpdate()
    fetchCities()
    initializePageViewController()
    setMetricSystemSegmentedControl()
    addNotificationCenterObserver()
    setNetworkManagerWhenInternetIsNotAvailable()
    setPageControl()
  }
  
  func setupLayout() {
    view.bringSubviewToFront(pageControl)
  }
  
}


// MARK: - Private - Fetch cities and set new CoreData attribute lastUpdate if not exists.
private extension ForecastViewController {
  
  func fetchCitiesAndSetLastUpdate() {
    LocalizedCityManager.setCitiesLastUpdateDateAfterCoreDataMigration()
  }
}


// MARK: - Private - fetch cities
private extension ForecastViewController {
  
  func fetchCities() {
    do {
      try cities.performFetch()

    } catch {
      CoreDataError.couldNotFetch.handle()
    }
  }
  
}


// MARK: - Private - Initialize PageViewController
private extension ForecastViewController {
  
  func initializePageViewController() {
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMove(toParent: self)
  }
  
}


// MARK: - Private - Set metric system segmented control
private extension ForecastViewController {
  
  func setMetricSystemSegmentedControl() {
    navigationItem.titleView = measuringSystemSegmentedControl
  }
  
}


// MARK: - Private - NotificationCenter
private extension ForecastViewController {
  
  func addNotificationCenterObserver() {
    let reloadPagesName = NotificationCenterKey.reloadPagesNotification.name
    NotificationCenter.default.addObserver(self, selector: #selector(reloadPages(_:)), name: reloadPagesName, object: nil)
    
    let reloadDataName = NotificationCenterKey.reloadPagesDataNotification.name
    NotificationCenter.default.addObserver(self, selector: #selector(reloadPagesData(_:)), name: reloadDataName, object: nil)
  }
  
  func removeNotificationCenterObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
}


// MARK: - Private - Set page control
private extension ForecastViewController {
  
  func setPageControl() {
    pageControl.currentPage = currentIndex
    pageControl.numberOfPages = cityCount
  }
  
}


// MARK: - Private - Set NetworkManager when internet is not available
private extension ForecastViewController {
  
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
private extension ForecastViewController {
  
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
extension ForecastViewController {
  
  @objc func reloadPages(_ notification: NSNotification) {
    fetchCities()
    setInitialViewController()
    setPageControl()
  }
  
  @objc func reloadPagesData(_ notification: NSNotification) {
    fetchCities()
    setPageControl()
  }
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    let notificationName = NotificationCenterKey.measuringSystemDidSwitchNotification.name
    
    let segmentedControlData: [String: SegmentedControl] = ["SegmentedControl": sender]
    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: segmentedControlData)
  }
  
  @IBAction func poweredByButtonTapped(_ sender: UIBarButtonItem) {
    if let url = URL(string: "https://darksky.net/poweredby/") {
      let safariViewController = SFSafariViewController(url: url)
      present(safariViewController, animated: true)
    }
  }
  
}


// MARK: - CityListTableViewControllerDelegate protocol
extension ForecastViewController: CityListTableViewControllerDelegate {
  
  func cityListController(_ cityListTableViewController: ForecastCityTableViewController, didSelect city: City) {
    guard let newPageIndex = cities.indexPath(forObject: city)?.row else { return }
  
    moveToPage(at: newPageIndex) {
      self.currentIndex = newPageIndex
      self.pendingIndex = nil
    }
  }
  
}


// MARK: - Private - Move to page at index
private extension ForecastViewController {
  
  func moveToPage(at index: Int, completion: (() -> ())? = nil) {
    guard let vc = forecastContentViewController(at: index) else { return }
    guard index < cityCount else { return }
    
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
private extension ForecastViewController {

  func setInitialViewController(at index: Int = 0) {
    guard let forecastContentVC = forecastContentViewController(at: index) else { return }
    pageViewController.setViewControllers([forecastContentVC], direction: .forward, animated: false)
  }

}


// MARK: - Private - Get ForecastPageViewController
private extension ForecastViewController {
  
  func forecastContentViewController(at index: Int) -> ForecastContentViewController? {
    var forecastVC: ForecastContentViewController!
    
    if !contentViewiewControllers.isEmpty && index <= contentViewiewControllers.count - 1 {
      forecastVC = contentViewiewControllers[index]
    } else {
      let storyboard = UIStoryboard(storyboard: .main)
      forecastVC = storyboard.instantiateViewController(ForecastContentViewController.self)
      contentViewiewControllers.append(forecastVC)
    }
    
    forecastVC.pageIndex = index
    
    if cityCount > 0 {
      let indexPath = IndexPath(row: index, section: 0)
      let city = cities.object(at: indexPath)
      forecastVC.currentCityForecast = city
    } else {
      forecastVC.currentCityForecast = nil
    }

    return forecastVC
  }
  
  func index(of forecastContentViewController: ForecastContentViewController) -> Int {
    guard let city = forecastContentViewController.currentCityForecast else { return NSNotFound }
    return cities.indexPath(forObject: city)?.row ?? NSNotFound
  }
  
}


// MARK: - UIPageViewControllerDataSource protocol
extension ForecastViewController: UIPageViewControllerDataSource {
  
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
    if indexOfViewController == NSNotFound || (indexOfViewController + 1) == cityCount {
      return nil
    }

    return forecastContentViewController(at: indexOfViewController + 1)
  }
  
}


// MARK: - UIPageViewControllerDelegate protocol
extension ForecastViewController: UIPageViewControllerDelegate {
  
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
