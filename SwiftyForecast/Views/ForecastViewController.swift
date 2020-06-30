import UIKit
import RealmSwift

final class ForecastViewController: UIViewController {
  @IBOutlet private weak var pageControl: UIPageControl!
  
  private lazy var notationSystemSegmentedControl: SegmentedControl = {
    typealias ForecastMainStyle = Style.ForecastMainVC
    
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = [TemperatureNotation.fahrenheit, TemperatureNotation.celsius]
    segmentedControl.font = ForecastMainStyle.measuringSystemSegmentedControlFont
    segmentedControl.borderWidth = ForecastMainStyle.measuringSystemSegmentedControlBorderWidth
    segmentedControl.selectedLabelColor = ForecastMainStyle.measuringSystemSegmentedControlSelectedLabelColor
    segmentedControl.unselectedLabelColor = ForecastMainStyle.measuringSystemSegmentedControlUnselectedLabelColor
    segmentedControl.borderColor = ForecastMainStyle.measuringSystemSegmentedControlBorderColor
    segmentedControl.thumbColor = ForecastMainStyle.measuringSystemSegmentedControlThumbColor
    segmentedControl.backgroundColor = ForecastMainStyle.measuringSystemSegmentedControlBackgroundColor
    segmentedControl.selectedIndex = ForecastUserDefaults.unitNotation.rawValue
    segmentedControl.addTarget(self, action: #selector(measuringSystemSwitched), for: .valueChanged)
    return segmentedControl
  }()
  
  private lazy var pageViewController: UIPageViewController = {
    var viewControllers: [UIViewController] {
      guard let contentViewModels = viewModel?.contentViewModels else { return [] }
      
      var controllers: [UIViewController] = []
      for (index, _) in contentViewModels.enumerated() {
        if let viewController = forecastContentViewController(at: index) {
          controllers.append(viewController)
        }
      }
      
      return controllers
    }
    
    let storyboard = UIStoryboard(storyboard: .main)
    let viewController = storyboard.instantiateViewController(UIPageViewController.self)
    viewController.dataSource = self
    viewController.delegate = self
    viewController.setViewControllers(viewControllers, direction: .forward, animated: true)
    return viewController
  }()
  
  private var pendingIndex: Int? {
    viewModel?.pendingIndex
  }
  
  private var currentIndex: Int {
    return viewModel?.currentIndex ?? 0
  }
  private var cityCount: Int {
    return viewModel?.numberOfCities ?? 0
  }
  
  private var contentViewiewControllers: [ContentViewController] = []
  var viewModel: ForecastViewModel? = DefaultForecastViewModel(service: DefaultForecastService())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showOrHideLocationServicesPrompt()
    loadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.showCitySelectionSegue.rawValue else { return }
    guard let viewController = segue.destination as? CitySelectionViewController else { return }
    
    viewController.viewModel = DefaultCitySelectionViewModel(delegate: viewController)
    viewController.delegate = self
    viewController.isModalInPresentation = true
  }
  
  deinit {
    removeNotificationObservers()
  }
}

// MARK: - ViewSetupable protocol
extension ForecastViewController: ViewSetupable {
  
  func setUp() {
    setViewModelClosureCallbacks()
    addNotificationObservers()
  }
  
  func setViewModelCallback() {
    viewModel?.onIndexUpdate = { [weak self] currentIndex in
      self?.pageControl.currentPage = currentIndex
    }
  }
  
  func addChildPageViewController() {
    add(pageViewController)
  }
  
  func setNotationSystemSegmentedControl() {
    navigationItem.titleView = notationSystemSegmentedControl
  }
  
  func setupPageControl() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.pageControl.currentPage = self.currentIndex
      self.pageControl.numberOfPages = self.cityCount
      self.view.bringSubviewToFront(self.pageControl)
    }
  }
  
}

// MARK: - Private - Reload data
private extension ForecastViewController {
  
  func loadData() {
    viewModel?.loadData()
  }

}

// MARK: - Private - Setup notification center
private extension ForecastViewController {
  
  func addNotificationObservers() {
//    ForecastNotificationCenter.add(observer: self, selector: #selector(reloadPages), for: .reloadPages)
//    ForecastNotificationCenter.add(observer: self, selector: #selector(reloadPagesData), for: .reloadPagesData)
    ForecastNotificationCenter.add(observer: self, selector: #selector(locationServiceDidRequestLocation), for: .locationServiceDidRequestLocation)
    ForecastNotificationCenter.add(observer: self, selector: #selector(applicationDidBecomeActive), for: .applicationDidBecomeActive)
  }
  
  func removeNotificationObservers() {
    ForecastNotificationCenter.remove(observer: self)
  }
  
}

// MARK: - Private - Show or hide navigation prompt
private extension ForecastViewController {
  
  func showOrHideLocationServicesPrompt() {
    let delayInSeconds = 1.0
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
  
//  @objc func reloadPages(_ notification: NSNotification) {
//    setInitialViewController()
//    setupPageControl()
//  }
//
//  @objc func reloadPagesData(_ notification: NSNotification) {
//    setupPageControl()
//  }
  
  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    viewModel?.measuringSystemSwitched(sender)
  }
  
  @IBAction func poweredByButtonTapped(_ sender: UIBarButtonItem) {
    viewModel?.presentPoweredBy(at: self)
  }
  
  @objc func locationServiceDidRequestLocation(_ notification: NSNotification) {
    loadData()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    loadData()
  }
  
}

// MARK: - CityListTableViewControllerDelegate protocol
extension ForecastViewController: CitySelectionViewControllerDelegate {
  
  func citySelection(_ view: CitySelectionViewController, didSelect city: City) {
    guard let index = viewModel?.index(of: city) else { return }
    
    moveToPage(at: index) { [weak self] _ in
      self?.viewModel?.currentIndex = index
      self?.viewModel?.pendingIndex = nil
    }
  }
  
}

// MARK: - Private - Move to page at index
private extension ForecastViewController {
  
  func moveToPage(at index: Int, completion: @escaping (Bool) -> Void) {
    guard index < cityCount else { return }
    guard let contentViewController = forecastContentViewController(at: index) else { return }
    
    if index > currentIndex {
      pageViewController.setViewControllers([contentViewController],
                                            direction: .forward,
                                            animated: false,
                                            completion: completion)
      
    } else if index < currentIndex {
      pageViewController.setViewControllers([contentViewController],
                                            direction: .reverse,
                                            animated: false,
                                            completion: completion)
    }
  }
  
}

// MARK: - Private - Set dataSource and first ViewController
private extension ForecastViewController {
  
  func setInitialViewController() {
    guard let viewController = forecastContentViewController(at: 0) else { return }
    pageViewController.setViewControllers([viewController], direction: .forward, animated: false)
  }
  
}

// MARK: - Private - Get ForecastPageViewController
private extension ForecastViewController {
  
  func forecastContentViewController(at index: Int) -> ContentViewController? {
    guard let contentViewController = viewModel?.contentViewController(at: index) else {
      return nil
    }
    
    if contentViewiewControllers.contains(contentViewController) {
      return contentViewiewControllers[safe: index]
    } else {
      contentViewiewControllers.append(contentViewController)
      return contentViewController
    }
  }
  
}

// MARK: - UIPageViewControllerDataSource protocol
extension ForecastViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let pageContentViewController = viewController as? ContentViewController else { return nil }
    
    let viewControllerIndex = pageContentViewController.pageIndex
    if viewControllerIndex == NSNotFound || viewControllerIndex == 0 {
      return nil
    }
    
    return forecastContentViewController(at: viewControllerIndex - 1)
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let pageContentViewController = viewController as? ContentViewController else { return nil }
    
    let viewControllerIndex = pageContentViewController.pageIndex
    if viewControllerIndex == NSNotFound || (viewControllerIndex + 1) == cityCount {
      return nil
    }
    
    return forecastContentViewController(at: viewControllerIndex + 1)
  }
  
}

// MARK: - UIPageViewControllerDelegate protocol
extension ForecastViewController: UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let viewController = pendingViewControllers.first as? ContentViewController else { return }
    viewModel?.pendingIndex = viewController.pageIndex
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    guard completed, let currentPageIndex = pendingIndex else { return }
    viewModel?.currentIndex = currentPageIndex
  }
  
}

// MAKR: - Private - Set view models closures
private extension ForecastViewController {
  
  func setViewModelClosureCallbacks() {
    viewModel?.onSuccess = {
      DispatchQueue.main.async { [weak self] in
        self?.addChildPageViewController()
        self?.setupPageControl()
        self?.setNotationSystemSegmentedControl()
      }
    }
    
    viewModel?.onFailure = { error in
      DispatchQueue.main.async {
        if case GeocoderError.locationDisabled = error {
          LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
        } else {
          (error as? ErrorHandleable)?.handler()
        }
      }
    }
    
    viewModel?.onLoadingStatus = { isLoading in
      DispatchQueue.main.async {
        if isLoading {
          ActivityIndicatorView.shared.startAnimating()
        } else {
          ActivityIndicatorView.shared.stopAnimating()
        }
      }
    }
  }
  
}
