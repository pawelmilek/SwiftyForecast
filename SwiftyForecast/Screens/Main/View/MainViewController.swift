import UIKit
import TipKit
import CoreLocation
import Combine

final class MainViewController: UIViewController {
    var coordinator: MainCoordinator?
    var viewModel: MainViewControllerViewModel? {
        didSet {
            pageViewController.onDidChangePageNavigation = { [weak self] index in
                self?.viewModel?.onDidChangePageNavigation(index: index)
            }
        }
    }

    private let lottieAnimationViewController = LottieAnimationViewController()

    private lazy var infoBarButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "info")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.openInfoBarButtonTapped()
           })
        return button
    }()

    private lazy var appearanceBarButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "paintpalette.fill")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.openAppearanceBarButtonTapped()
           })
        return button
    }()

    private lazy var leftBarButtonHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoBarButton, appearanceBarButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private lazy var locationBarButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.image = UIImage(systemName: "location.fill")
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: UIAction() { [weak self] _ in
            self?.openLocationListBarButtonTapped()
           })
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

    private let pageViewController = MainPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private let reviewManager = ReviewManager(
        bundle: .main,
        storage: .standard,
        configuration: DecodedPlist(
            name: "ReviewDesirableMomentConfig",
            bundle: .main
        )
    )
    private let locationManager = LocationManager()
    private let informationTip = InformationTip()
    private let appearanceTip = AppearanceTip()

    private var informationTipObservationTask: Task<Void, Never>?
    private weak var informationTipPopoverController: TipUIPopoverViewController?
    private var appearanceTipObservationTask: Task<Void, Never>?
    private weak var appearanceTipPopoverController: TipUIPopoverViewController?
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
        viewModel.$currentWeatherViewModels
            .filter { !$0.isEmpty }
            .map { $0.map { WeatherViewController.make(viewModel: $0) } }
            .sink { [weak self] viewControllers in
                self?.pageViewController.set(viewControllers: viewControllers)
            }
            .store(in: &cancellables)

        viewModel.shouldNavigateToCurrentPage
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                viewModel.onDidChangePageNavigation(index: MainViewControllerViewModel.userLocationPageIndex)
                self?.transitionToCurrentViewController()
            }
            .store(in: &cancellables)
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
        pageViewController.display(at: index)
    }
}

// MARK: - AppStoreReviewObserverEventResponder
extension MainViewController: ReviewObserverEventResponder {
    func reviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType) {
        reviewManager.requestReview(for: desirableMoment)
    }
}
