import UIKit
import CoreLocation
import RealmSwift
import Combine

final class MainViewController: UIViewController {
    var coordinator: MainCoordinator?
    var viewModel: MainViewController.ViewModel?

    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        return viewController
    }()

    private lazy var notationSegmentedControl: SegmentedControl = {
        let frame = CGRect(x: 0, y: 0, width: 170, height: 25)
        let segmentedControl = SegmentedControl(frame: frame)
        segmentedControl.items = viewModel?.notationSegmentedControlItems ?? []
        segmentedControl.selectedIndex = viewModel?.notationSegmentedControlDefaultIndex ?? 0
        segmentedControl.addTarget(
            self,
            action: #selector(temperatureNotationSystemDidChange),
            for: .valueChanged
        )
        return segmentedControl
    }()

    private var locationManager: LocationManager?
    private var appStoreReviewManager: AppStoreReviewManager?
    private var appStoreReviewObserver: AppStoreReviewObserver?
    private var pageViewControllers: [WeatherViewController] = []
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    deinit {
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }
}

// MARK: - Private - SetUps
private extension MainViewController {

    func setup() {
        setLocationManager()
        subscribeToLocationManager()
        subscribeToViewModel()
        setupAppStoreReview()
        setupPoweredByLeftBarButtonItem()
        setNotationSystemSegmentedControl()
        addNotificationObservers()
        setupChildaPageViewController()
        setupAppearance()
    }

    func setLocationManager() {
        locationManager = LocationManager()
    }

    func subscribeToLocationManager() {
        locationManager?.$authorizationStatus
            .sink { [self] authorizationStatus in
                switch authorizationStatus {
                case .notDetermined:
                    locationManager?.requestAuthorization()

                case .authorizedWhenInUse, .authorizedAlways:
                    locationManager?.requestLocation()

                default:
                    showEnableLocationServicesPrompt()
                }
            }
            .store(in: &cancellables)

        locationManager?.$currentLocation
            .print()
            .compactMap { $0 }
            .sink { [self] location in
                viewModel?.onUpdateUserLocation(location)
            }
            .store(in: &cancellables)

        locationManager?.$error
            .compactMap { $0 }
            .sink { error in
                AlertViewPresenter.shared.presentError(withMessage: error.localizedDescription)
            }
            .store(in: &cancellables)

    }

    func subscribeToViewModel() {
        guard let viewModel else { return }

        viewModel.$currentWeatherViewModels
            .sink { [self] currentWeatherViewModels in
                pageViewControllers = currentWeatherViewModels.compactMap {
                    WeatherViewController.make(viewModel: $0)
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(
            viewModel.$previousPageIndex,
            viewModel.$currentPageIndex
        )
        .dropFirst()
        .sink { [self] newValue in
            transition(
                fromPageIndex: newValue.0,
                toPageIndex: newValue.1
            )
        }
        .store(in: &cancellables)

        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    ActivityIndicatorView.shared.startAnimating()
                } else {
                    ActivityIndicatorView.shared.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    func setupAppStoreReview() {
        appStoreReviewManager = AppStoreReviewManager()
        setupAppStoreReviewObserver()
    }

    func setupAppStoreReviewObserver() {
        appStoreReviewObserver = AppStoreReviewObserver()
        appStoreReviewObserver?.eventResponder = self
        appStoreReviewObserver?.startObserving()
    }

    func showEnableLocationServicesPrompt() {
        guard let navigationController = self.navigationController else { return }
        viewModel?.showEnableLocationServicesPrompt(at: navigationController)
    }

    func setupPoweredByLeftBarButtonItem() {
        let imageSize = CGSize(width: 52, height: 22)
        let button = UIButton()
        button.setImage(UIImage.icPoweredby, for: .normal)

        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButton.customView?.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        barButton.customView?.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true

        button.addTarget(self, action: #selector(poweredByBarButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = barButton
    }

    @objc func poweredByBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let url = viewModel?.powerByURL else { return }
        coordinator?.openWeatherAPISoruceWebPage(url: url)
    }

    func setNotationSystemSegmentedControl() {
        navigationItem.titleView = notationSegmentedControl
    }

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: .applicationDidBecomeActive,
            object: nil
        )
    }

    func setupChildaPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        add(pageViewController)
    }

    func setupAppearance() {
        notationSegmentedControl.font = Style.Main.segmentedControlFont
        notationSegmentedControl.borderWidth = Style.Main.segmentedControlBorderWidth
        notationSegmentedControl.selectedLabelColor = Style.Main.segmentedControlSelectedLabelColor
        notationSegmentedControl.unselectedLabelColor = Style.Main.segmentedControlUnselectedLabelColor
        notationSegmentedControl.borderColor = Style.Main.segmentedControlBorderColor
        notationSegmentedControl.thumbColor = Style.Main.segmentedControlThumbColor
        notationSegmentedControl.backgroundColor = Style.Main.segmentedControlBackgroundColor

        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = Style.Main.pageIndicatorTintColor
        proxy.currentPageIndicatorTintColor = Style.Main.currentPageIndicatorColor
        view.backgroundColor = Style.Main.backgroundColor
    }

}

// MARK: - Actions
extension MainViewController {

    @IBAction func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.openLocationListViewController()
    }

    @objc func temperatureNotationSystemDidChange(_ sender: SegmentedControl) {
        viewModel?.temperatureNotationSystemChanged(sender)
    }

    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        locationManager?.requestLocation()
    }

}

// MARK: - LocationListSelectionViewControllerDelegate
extension MainViewController: LocationListViewControllerDelegate {

    func locationListViewController(
        _ view: LocationListViewController,
        didTapSearchLocationButton sender: UIButton
    ) {
        coordinator?.openLocationSearchViewController()
    }

    func locationListViewController(
        _ view: LocationListViewController,
        didSelectLocationAt index: Int
    ) {
        viewModel?.onSelectLocation(at: index)
        coordinator?.popTopViewControllerFromBottom()
    }

}

// MARK: - Private - Transition page view controllers
private extension MainViewController {

    func transition(fromPageIndex: Int, toPageIndex: Int, completion: ((Bool) -> Void)? = nil) {
        guard let viewController = pageViewControllers[safe: toPageIndex] else { return }

        if toPageIndex > fromPageIndex {
            pageViewController.setViewControllers([viewController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: completion)

        } else if toPageIndex < fromPageIndex {
            pageViewController.setViewControllers([viewController],
                                                  direction: .reverse,
                                                  animated: false,
                                                  completion: completion)
        } else if toPageIndex == fromPageIndex {
            pageViewController.setViewControllers([viewController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: completion)
        }
    }

}

// MARK: - UIPageViewControllerDataSource
extension MainViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else {
            return nil
        }
        guard let pageIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        if pageIndex == NSNotFound || pageIndex == 0 {
            return nil
        }

        let beforePageIndex = pageIndex - 1
        return pageViewControllers[safe: beforePageIndex]

    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else {
            return nil
        }
        guard let pageIndex = pageViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let maxNumberOfPageViewControllers = pageViewControllers.count
        let afterPageIndex = pageIndex + 1

        if afterPageIndex == NSNotFound || afterPageIndex == maxNumberOfPageViewControllers {
            return nil
        }

        return pageViewControllers[safe: afterPageIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pageViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = self.pageViewController.viewControllers?.first as? WeatherViewController else {
            return 0
        }

        guard let currentPageIndex = pageViewControllers.firstIndex(of: viewController) else {
            return 0
        }

        return currentPageIndex
    }

}

// MARK: - UIPageViewControllerDelegate
extension MainViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        //        guard let viewController = pendingViewControllers.first as? WeatherViewController else { return }
        //        viewModel?.onBeginTransition(at: viewController.pageIndex)
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        //        guard completed, let pendingIndex = viewModel?.pendingIndex else { return }
        //        viewModel?.onEndTransition(at: pendingIndex)
        guard completed else { return }
        pageTransitionImpactFeedback()
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }

    private func pageTransitionImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

}

// MARK: - AppStoreReviewObserverEventResponder
extension MainViewController: AppStoreReviewObserverEventResponder {

    func appStoreReviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType) {
        appStoreReviewManager?.requestReview(for: desirableMoment)
    }

}

// MARK: - Factory method
extension MainViewController {

    static func make() -> MainViewController {
        return UIViewController.make(MainViewController.self, from: .main)
    }

}
