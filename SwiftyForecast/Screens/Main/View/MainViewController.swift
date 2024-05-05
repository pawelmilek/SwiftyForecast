import UIKit
import TipKit
import CoreLocation
import Combine

final class MainViewController: UIViewController {
    var coordinator: MainCoordinator?
    var viewModel: MainViewControllerViewModel?

    private let lottieAnimationViewController = LottieAnimationViewController()

    private lazy var infoBarButton: UIButton = {
        let image = UIImage(systemName: "info.circle")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(openInfoBarButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var appearanceBarButton: UIButton = {
        let image = UIImage(systemName: "circle.lefthalf.filled.inverse")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(openAppearanceBarButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var leftBarButtonHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoBarButton, appearanceBarButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    private lazy var locationBarButton: UIButton = {
        let image = UIImage(systemName: "mappin.circle")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(openLocationListBarButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var notationSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: viewModel?.notationSegmentedControlItems ?? [])
        control.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        control.selectedSegmentIndex = viewModel?.notationSegmentedControlIndex ?? 0
        control.addAction( UIAction { [weak self] action in
            guard let sender = action.sender as? UISegmentedControl else { return }
            self?.viewModel?.onSegmentedControlDidChange(sender.selectedSegmentIndex)
        }, for: .valueChanged)

        return control
    }()

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private let reviewManager = ReviewManager(bundle: .main, storage: .standard)
    private let locationManager = LocationManager()
    private let informationTip = InformationTip()
    private let appearanceTip = AppearanceTip()

    private var informationTipObservationTask: Task<Void, Never>?
    private weak var informationTipPopoverController: TipUIPopoverViewController?
    private var appearanceTipObservationTask: Task<Void, Never>?
    private weak var appearanceTipPopoverController: TipUIPopoverViewController?

    private var viewControllers: [WeatherViewController] = []
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTipObservationTasks()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.onViewDidDisappear()
        stopTipObservationTasks()
    }
}

// MARK: - Private - SetUps
private extension MainViewController {

    func setup() {
        subscribeToLocationManager()
        subscribeToViewModel()
        setupChildaPageViewController()
        setupNavigationItems()
        setupAppearance()
    }

    func subscribeToLocationManager() {
        locationManager.$authorizationStatus
            .sink { [weak self] authorizationStatus in
                self?.verifyLocation(authorizationStatus: authorizationStatus)
            }
            .store(in: &cancellables)

        locationManager.$isObtainingLocation
            .sink { [weak self] isObtainingLocation in
                self?.presentObtainingLocationAnimationIfNeeded(isObtainingLocation)
            }
            .store(in: &cancellables)

        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [self] currentLocation in
                viewModel?.onDidUpdateLocation(currentLocation)
            }
            .store(in: &cancellables)

        locationManager.$error
            .compactMap { $0 }
            .sink { error in
                debugPrint(error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    func subscribeToViewModel() {
        guard let viewModel else { return }
        viewModel.shouldNavigateToCurrentPage
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                viewModel.onDidChangePageNavigation(index: MainViewControllerViewModel.userLocationPageIndex)
                self?.transitionToCurrentViewController()
            }
            .store(in: &cancellables)

        viewModel.$currentWeatherViewModels
            .filter { !$0.isEmpty }
            .map { viewModels -> [WeatherViewController] in
                viewModels.map { WeatherViewController.make(viewModel: $0) }
            }
            .sink { [weak self] viewControllers in
                self?.reloadPages(viewControllers)
            }
            .store(in: &cancellables)
    }

    func reloadPages(_ weatherViewControllers: [WeatherViewController]) {
        self.viewControllers.removeAll()
        self.viewControllers.append(contentsOf: weatherViewControllers)
    }

    func verifyLocation(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()

        default:
            showEnableLocationServicesPrompt()
        }
    }

    func presentObtainingLocationAnimationIfNeeded(_ isObtainingLocation: Bool) {
        if isObtainingLocation {
            self.parent?.present(lottieAnimationViewController, animated: false)
        } else {
            lottieAnimationViewController.dismiss(animated: false)
        }
    }

    func showEnableLocationServicesPrompt() {
        guard let navigationController = self.navigationController else { return }
        viewModel?.showEnableLocationServicesPrompt(at: navigationController)
    }

    func setupNavigationItems() {
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
        setupNotationSystemSegmentedControl()
    }

    func setupLeftBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonHorizontalStackView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func setupRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(customView: locationBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc
    func openInfoBarButtonTapped() {
        coordinator?.openAboutViewController()
        donateInformationVisitEvent()
    }

    func donateInformationVisitEvent() {
        Task(priority: .userInitiated) {
            await InformationTip.visitViewEvent.donate()
        }
    }

    @objc
    func openAppearanceBarButtonTapped() {
        coordinator?.openAppearanceViewController()
        AppearanceTip.showTip = false
    }

    @objc func openLocationListBarButtonTapped() {
        coordinator?.openLocationListViewController()
    }

    func setupNotationSystemSegmentedControl() {
        navigationItem.titleView = notationSegmentedControl
    }

    func setupChildaPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        add(pageViewController)
    }

    func setupAppearance() {
        let proxyPageControl = UIPageControl.appearance()
        proxyPageControl.pageIndicatorTintColor = Style.Main.pageIndicatorTintColor
        proxyPageControl.currentPageIndicatorTintColor = .customPrimary
        view.backgroundColor = Style.Main.backgroundColor
    }

    func setupTipObservationTasks() {
        setInformationTipObservationTask()
        setAppearanceTipObservationTask()
    }

    func setInformationTipObservationTask() {
        informationTipObservationTask = informationTipObservationTask ?? Task { @MainActor in
            for await shouldDisplay in informationTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let popoverController = TipUIPopoverViewController(
                        informationTip,
                        sourceItem: infoBarButton
                    )
                    popoverController.view.tintColor = .customPrimary
                    present(popoverController, animated: true)
                    informationTipPopoverController = popoverController
                } else {
                    if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                        informationTipPopoverController = nil
                    }
                }
            }
        }
    }

    func setAppearanceTipObservationTask() {
        appearanceTipObservationTask = appearanceTipObservationTask ?? Task { @MainActor in
            for await shouldDisplay in appearanceTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let popoverController = TipUIPopoverViewController(
                        appearanceTip,
                        sourceItem: appearanceBarButton
                    )
                    popoverController.view.tintColor = .customPrimary
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.present(popoverController, animated: true)
                        self.appearanceTipPopoverController = popoverController
                    }
                } else {
                    if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                        appearanceTipPopoverController = nil
                    }
                }
            }
        }
    }

    func stopTipObservationTasks() {
        informationTipObservationTask?.cancel()
        informationTipObservationTask = nil

        appearanceTipObservationTask?.cancel()
        appearanceTipObservationTask = nil
    }
}

// MARK: - LocationListSelectionViewControllerDelegate
extension MainViewController: LocationSearchViewControllerDelegate {
    func locationListViewController(
        _ view: LocationSearchViewController,
        didSelectLocation location: LocationModel
    ) {
        guard let index = viewModel?.index(of: location) else { return }
        viewModel?.onDidChangePageNavigation(index: index)
        coordinator?.dismissViewController()
        transitionToCurrentViewController()
    }

    private func transitionToCurrentViewController() {
        guard let index = viewModel?.currentPageIndex else { return }

        let viewController = viewControllers[index]
        pageViewController.setViewControllers(
            [viewController],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else {
            return nil
        }

        guard let pageIndex = viewControllers.firstIndex(where: {
            $0.viewModel?.compoundKey == viewController.viewModel?.compoundKey
        }) else {
            return nil
        }

        let previousIndex = pageIndex - 1
        let firstPageIndex = 0
        guard previousIndex >= firstPageIndex else {
            return nil
        }

        return viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherViewController else {
            return nil
        }

        guard let pageIndex = viewControllers.firstIndex(where: {
            $0.viewModel?.compoundKey == viewController.viewModel?.compoundKey
        }) else {
            return nil
        }

        let nextIndex = pageIndex + 1
        let lastPageIndex = viewControllers.count - 1
        guard nextIndex <= lastPageIndex else {
            return nil
        }

        return viewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        viewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        viewModel?.currentPageIndex ?? 0
    }
}

// MARK: - UIPageViewControllerDelegate
extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let viewController = pageViewController.viewControllers?.first as? WeatherViewController else { return }
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return }

        viewModel?.onDidChangePageNavigation(index: currentIndex)
        pageTransitionImpactFeedback()
    }

    private func pageTransitionImpactFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}

// MARK: - AppStoreReviewObserverEventResponder
extension MainViewController: ReviewObserverEventResponder {
    func reviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType) {
        reviewManager.requestReview(for: desirableMoment)
    }
}
