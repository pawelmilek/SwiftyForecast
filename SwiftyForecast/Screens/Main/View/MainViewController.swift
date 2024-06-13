import UIKit
import TipKit
import CoreLocation
import Combine

final class MainViewController: UIViewController {
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
        let control = UISegmentedControl(items: viewModel.notationSegmentedControlItems)
        control.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        control.addAction( UIAction { [weak self] action in
            guard let sender = action.sender as? UISegmentedControl else { return }
            self?.viewModel.onSegmentedControlDidChange(sender.selectedSegmentIndex)
            UIImpactFeedbackGenerator().impactOccurred()
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
    private let informationTip = InformationTip()
    private let appearanceTip = AppearanceTip()

    private var informationTipObservationTask: Task<Void, Never>?
    private weak var informationTipPopoverController: TipUIPopoverViewController?
    private var appearanceTipObservationTask: Task<Void, Never>?
    private weak var appearanceTipPopoverController: TipUIPopoverViewController?
    private var cancellables = Set<AnyCancellable>()

    let coordinator: Coordinator
    var viewModel: MainViewControllerViewModel

    init?(
        viewModel: MainViewControllerViewModel,
        coordinator: Coordinator,
        coder: NSCoder
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(viewModel:coordinator:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.onViewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTipObservationTasks()
        viewModel.onViewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTipObservationTasks()
    }
}

// MARK: - Private - SetUps
private extension MainViewController {

    func setup() {
        subscribeToViewModel()
        setupChildaPageViewController()
        setupNavigationItems()
        setupAppearance()
    }

    func subscribeToViewModel() {
        viewModel.$notationSegmentedControlIndex
            .assign(to: \.selectedSegmentIndex, on: notationSegmentedControl)
            .store(in: &cancellables)

        viewModel.$currentWeatherViewModels
            .filter { !$0.isEmpty }
            .map { $0.map { WeatherViewController.make(viewModel: $0) } }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewControllers in
                guard let self else { return }
                pageViewController.set(viewControllers)
                pageTransition(at: MainViewControllerViewModel.currentLocationIndex)
            }
            .store(in: &cancellables)

        viewModel.$isRequestingLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRequestingLocation in
                self?.coordinator.presentLocationAnimation(isLoading: isRequestingLocation)
            }
            .store(in: &cancellables)

        viewModel.$locationError
            .receive(on: DispatchQueue.main)
            .sink { locationError in
                guard let locationError else { return }
                debugPrint(locationError.localizedDescription)
            }
            .store(in: &cancellables)

//        viewModel.$hasUpdatedViewModels
//            .filter { $0 }
//            .receive(on: DispatchQueue.main)
//            .sink { hasUpdatedViewModels in
//
//            }
//            .store(in: &cancellables)
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
        coordinator.openAbout()
    }

    @objc
    func openAppearanceBarButtonTapped() {
        coordinator.openAppearanceSwitch()
    }

    @objc func openLocationListBarButtonTapped() {
        coordinator.openLocations()
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
        guard let index = viewModel.index(of: location) else { return }
        pageTransition(at: index)
        coordinator.dismiss()
    }

    private func pageTransition(at index: Int) {
        pageViewController.transition(at: index)
    }
}

// MARK: - AppStoreReviewObserverEventResponder
extension MainViewController: ReviewObserverEventResponder {
    func reviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType) {
        reviewManager.requestReview(for: desirableMoment)
    }
}
