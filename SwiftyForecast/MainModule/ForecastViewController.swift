import UIKit
import RealmSwift

final class ForecastViewController: UIViewController {
  @IBOutlet private weak var pageControl: UIPageControl!
  
  weak var coordinator: MainCoordinator?
  var viewModel: ForecastViewModel?
  
  private lazy var appStoreReviewObserver: AppStoreReviewObserver = {
    let observer = AppStoreReviewObserver()
    observer.eventResponder = self
    return observer
  }()
  
  private lazy var notationSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
    segmentedControl.items = [TemperatureNotation.fahrenheit, TemperatureNotation.celsius]
    segmentedControl.selectedIndex = NotationController().temperatureNotation.rawValue
    segmentedControl.addTarget(self, action: #selector(measuringSystemSwitched), for: .valueChanged)
    return segmentedControl
  }()
    
  private lazy var pageViewController: UIPageViewController = {
    let viewController = StoryboardViewControllerFactory.make(UIPageViewController.self, from: .main)
    viewController.dataSource = self
    viewController.delegate = self
    return viewController
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  deinit {
    removeNotificationObservers()
    stopAppStoreReviewObserver()
  }
}

// MARK: - Private - SetUps
private extension ForecastViewController {
  
  func setUp() {
    startAppStoreReviewObserver()
    setupAppearance()
    setNotationSystemSegmentedControl()
    setViewModelClosureCallbacks()
    addNotificationObservers()
    loadAllData()
  }
  
  func startAppStoreReviewObserver() {
    appStoreReviewObserver.startObserving()
  }
  
  func stopAppStoreReviewObserver() {
    appStoreReviewObserver.stopObserving()
  }
  
  func setPageViewController() {
    guard let viewControllers = viewModel?.currentVisibleViewControllers, !viewControllers.isEmpty else { return }
    
    pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false)
    add(pageViewController)
  }
  
  func setNotationSystemSegmentedControl() {
    navigationItem.titleView = notationSegmentedControl
  }
  
  func setViewModelClosureCallbacks() {
    DispatchQueue.main.async { [weak self] in
      self?.viewModel?.onIndexUpdate = { [weak self] _ in
        self?.setPageControl()
      }
    }
    
    viewModel?.onSuccess = {
      DispatchQueue.main.async { [weak self] in
        self?.setPageViewController()
        self?.setPageControl()
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
  
  func setPageControl() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.pageControl.numberOfPages = self.viewModel?.numberOfCities ?? 0
      self.pageControl.currentPage = self.viewModel?.currentIndex ?? 0
      self.view.bringSubviewToFront(self.pageControl)
    }
  }
  
  func pageTransitionImpactFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()
    generator.impactOccurred()
  }
  
  func setupAppearance() {
    notationSegmentedControl.font = Style.MainForecast.segmentedControlFont
    notationSegmentedControl.borderWidth = Style.MainForecast.segmentedControlBorderWidth
    notationSegmentedControl.selectedLabelColor = Style.MainForecast.segmentedControlSelectedLabelColor
    notationSegmentedControl.unselectedLabelColor = Style.MainForecast.segmentedControlUnselectedLabelColor
    notationSegmentedControl.borderColor = Style.MainForecast.segmentedControlBorderColor
    notationSegmentedControl.thumbColor = Style.MainForecast.segmentedControlThumbColor
    notationSegmentedControl.backgroundColor = Style.MainForecast.segmentedControlBackgroundColor
    
    pageControl.currentPageIndicatorTintColor = Style.MainForecast.currentPageIndicatorColor
    view.backgroundColor = Style.MainForecast.backgroundColor
  }
  
}

// MARK: - Private - Reload data
private extension ForecastViewController {
  
  func loadAllData() {
    viewModel?.loadAllData()
  }
  
  func loadData(at index: Int) {
    viewModel?.loadData(at: index)
  }

  func loadUserLocationData() {
    viewModel?.loadData(at: 0)
  }
}

// MARK: - Private - Setup notification center
private extension ForecastViewController {
  
  func addNotificationObservers() {
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(locationServiceDidRequestLocation),
                                   for: .locationServiceDidRequestLocation)
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(applicationDidBecomeActive),
                                   for: .applicationDidBecomeActive)
    
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(contentDataDidChange),
                                   for: .reloadContentPageData)
    
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(locationDidRemoveFromList),
                                   for: .cityRemovedFromLocationList)
    
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(locationProviderDidFailWithError),
                                   for: .locationProviderDidFail)
  }
  
  func removeNotificationObservers() {
    ForecastNotificationCenter.remove(observer: self)
  }

}

// MARK: - Private - Show or hide navigation prompt
private extension ForecastViewController {
  
  func renderLocationServicesPrompt() {
    guard let navigationController = self.navigationController else { return }
    viewModel?.showOrHideLocationServicesPrompt(at: navigationController)
  }
  
}

// MARK: - Actions
extension ForecastViewController {

  @IBAction func cityListSelectionBarButtonTapped(_ sender: UIBarButtonItem) {
    coordinator?.onTapCityListSelectionBarButton()
  }
  
  @IBAction func poweredByBarButtonTapped(_ sender: UIBarButtonItem) {
    let powerByURL = viewModel?.powerByURL
    coordinator?.onTapPoweredByBarButton(url: powerByURL)
  }

  @objc func measuringSystemSwitched(_ sender: SegmentedControl) {
    viewModel?.measuringSystemSwitched(sender)
  }

  @objc func locationServiceDidRequestLocation(_ notification: NSNotification) {
    loadUserLocationData()
  }
  
  @objc func applicationDidBecomeActive(_ notification: NSNotification) {
    renderLocationServicesPrompt()
    loadData(at: pageControl.currentPage)
  }
  
  @objc func contentDataDidChange(_ notification: NSNotification) {
    guard let value = notification.userInfo?[NotificationCenterUserInfo.cityUpdatedAtIndex.key],
      let index = value as? Int else { return }
    
    loadData(at: index)
    setPageControl()
  }
  
  @objc func locationDidRemoveFromList(_ notification: NSNotification) {
    guard let value = notification.userInfo?[NotificationCenterUserInfo.cityUpdated.key],
    let city = value as? CityDTO else { return }
    viewModel?.removeContentViewModel(with: LocationDTO(latitude: city.latitude, longitude: city.longitude))
  }
  
  @objc func locationProviderDidFailWithError() {
    AlertViewPresenter.presentPopupAlert(in: self,
                                         title: NSLocalizedString("Error", comment: ""),
                                         message: NSLocalizedString("Location provider failed", comment: ""))
  }
  
  @objc func presentLocationServicesSettingsPopupAlert() {
    let cancelAction: (UIAlertAction) -> () = { _ in }
    
    let settingsAction: (UIAlertAction) -> () = { _ in
      let settingsURL = URL(string: UIApplication.openSettingsURLString)!
      UIApplication.shared.open(settingsURL)
    }
    
    let title = NSLocalizedString("Location Services Disabled", comment: "")
    let message = NSLocalizedString("Please enable Location Services. We will keep your data private.", comment: "")
    let actionsTitle = [NSLocalizedString("Cancel", comment: ""), NSLocalizedString("Settings", comment: "")]
    
    AlertViewPresenter.presentPopupAlert(in: self,
                                         title: title,
                                         message: message,
                                         actionTitles: actionsTitle,
                                         actions: [cancelAction, settingsAction])
  }
  
}

// MARK: - CityListTableViewControllerDelegate protocol
extension ForecastViewController: CityListSelectionViewControllerDelegate {
  
  func cityListSelection(_ view: CityListSelectionViewController, didSelect index: Int) {
    loadData(at: index)
    setPageControl()
    moveToPage(at: index) { [weak self] _ in
      self?.viewModel?.currentIndex = index
      self?.viewModel?.pendingIndex = nil
    }
  }

}

// MARK: - Private - Move to page at index
private extension ForecastViewController {
  
  func moveToPage(at index: Int, completion: @escaping (Bool) -> Void) {
    guard let currentIndex = viewModel?.currentIndex else { return }
    guard let contentViewController = viewModel?.contentViewController(at: index) else { return }
    
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
    } else if index == currentIndex {
      pageViewController.setViewControllers([contentViewController],
                                            direction: .forward,
                                            animated: false,
                                            completion: completion)
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
    
    let beforeViewControllerIndex = viewControllerIndex - 1
    return viewModel?.contentViewController(at: beforeViewControllerIndex)
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let pageContentViewController = viewController as? ContentViewController else { return nil }
    
    let viewControllerIndex = pageContentViewController.pageIndex
    let cityCount = viewModel?.numberOfCities ?? 0
    let afterViewControllerIndex = viewControllerIndex + 1
    
    if viewControllerIndex == NSNotFound || afterViewControllerIndex == cityCount {
      return nil
    }
    
    return viewModel?.contentViewController(at: afterViewControllerIndex)
  }
  
}

// MARK: - UIPageViewControllerDelegate protocol
extension ForecastViewController: UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let viewController = pendingViewControllers.first as? ContentViewController else { return }
    viewModel?.pendingIndex = viewController.pageIndex
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    guard completed, let pendingIndex = viewModel?.pendingIndex else { return }
    viewModel?.currentIndex = pendingIndex
    
    if completed {
      pageTransitionImpactFeedback()
    }
  }
  
}

// MARK: - AppStoreReviewObserverEventResponder protocol
extension ForecastViewController: AppStoreReviewObserverEventResponder {

  func appStoreReviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType) {
    AppStoreReviewManager().requestReview(for: desirableMoment)
  }
  
}

// MARK: - Factory method
extension ForecastViewController {
  
  static func make() -> ForecastViewController {
    return StoryboardViewControllerFactory.make(ForecastViewController.self, from: .main)
  }

}
