import UIKit
import Combine

final class WeatherViewController: UIViewController {
    private enum Constant {
        static let weekdayCellHeight = CGFloat(53)
        static let hourlyCellsInRow = CGFloat(4)
        static let hourlySizeForItem = CGSize(width: 77, height: 65)
    }

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var dailyTableView: UITableView!
    private lazy var weatherCardViewController: CurrentWeatherCardViewController = {
        CurrentWeatherCardViewController(viewModel: cardViewModel)
    }()

    private let dailyForecastDataSource = DailyForecastDataSource()
    private let hourlyForcecastDataSource = HourlyForcecastDataSource()
    private let hourlyForecastFlowLayout = HourlyForecastFlowLayout(
        cellsInRow: Constant.hourlyCellsInRow,
        sizeForItem: Constant.hourlySizeForItem
    )
    private var cancellables = Set<AnyCancellable>()
    let viewModel: WeatherViewControllerViewModel
    private let cardViewModel: CurrentWeatherCardViewModel

    init?(
        viewModel: WeatherViewControllerViewModel,
        cardViewModel: CurrentWeatherCardViewModel,
        coder: NSCoder
    ) {
        self.viewModel = viewModel
        self.cardViewModel = cardViewModel
        super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayWeatherCardViewController()
        setup()
        loadData()
    }

    private func displayWeatherCardViewController() {
        self.addChild(weatherCardViewController)
        weatherCardViewController.view.frame = cardView.frame
        cardView.addSubview(weatherCardViewController.view)
        weatherCardViewController.didMove(toParent: self)
    }

    private func loadData() {
        viewModel.loadData()
    }

    private func loadHourlyData() {
        hourlyCollectionView.reloadData()
    }

    private func loadDailyData() {
        dailyTableView.reloadData()
    }
}

// MARK: - Private - Setup
private extension WeatherViewController {

    func setup() {
        setupAppearance()
        setupHourlyCollectionView()
        setupWeekTableView()
        subscriberPublishers()
        subscribeNotificationCenterPublisher()
    }

    func setupAppearance() {
        view.backgroundColor = Style.Weather.backgroundColor
        hourlyCollectionView.backgroundColor = Style.Weather.backgroundColor
        dailyTableView.backgroundColor = Style.Weather.tableViewBackgroundColor
        dailyTableView.separatorStyle = Style.Weather.tableViewSeparatorStyle
    }

    func setupHourlyCollectionView() {
        hourlyCollectionView.register(cellClass: HourlyViewCell.self)
        hourlyCollectionView.dataSource = hourlyForcecastDataSource
        hourlyCollectionView.delegate = hourlyForecastFlowLayout
        hourlyCollectionView.showsVerticalScrollIndicator = false
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        hourlyCollectionView.contentInsetAdjustmentBehavior = .never
    }

    func setupWeekTableView() {
        dailyTableView.register(cellClass: DailyViewCell.self)
        dailyTableView.dataSource = dailyForecastDataSource
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.allowsSelection = false
        dailyTableView.rowHeight = Constant.weekdayCellHeight
        dailyTableView.estimatedRowHeight = UITableView.automaticDimension
        dailyTableView.tableFooterView = UIView()
    }
}

// MARK: - Private - Subscribe publishers
private extension WeatherViewController {

    func subscriberPublishers() {
        subscribeWeatherPublisher()
        subscriberLoadingAndErrorPublishers()
        subscribeForecastPublishers()
    }

    func subscribeWeatherPublisher() {
        viewModel.$locationModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] locationModel in
                weatherCardViewController.loadData(at: locationModel)
            }
            .store(in: &cancellables)
    }

    func subscriberLoadingAndErrorPublishers() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [self] isLoading in
                if isLoading {
                    hideContent()

                } else {
                    showContent()
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { error in
                debugPrint(error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    func subscribeForecastPublishers() {
        viewModel.$twentyFourHoursForecastModel
            .combineLatest(viewModel.$fiveDaysForecastModel)
            .receive(on: DispatchQueue.main)
            .map {
                ($0.0.map {
                    HourlyViewCellViewModel(
                        model: $0,
                        temperatureRenderer: .init()
                    )
                },
                 $0.1.map {
                    DailyViewCellViewModel(
                        model: $0,
                        temperatureRenderer: .init()
                    )
                })
            }
            .sink { [self] (hourlyViewModels, dailyViewModels) in
                hourlyForcecastDataSource.set(viewModels: hourlyViewModels)
                dailyForecastDataSource.set(viewModeles: dailyViewModels)

                loadHourlyData()
                loadDailyData()
            }
            .store(in: &cancellables)
    }

    func subscribeNotificationCenterPublisher() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                viewModel.reloadCurrentLocation()
                weatherCardViewController.reloadCurrentLocation()
            }
            .store(in: &cancellables)
    }

    func showContent() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [self] in
            hourlyCollectionView.alpha = 1.0
            dailyTableView.alpha = 1.0
        }
    }

    func hideContent() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            hourlyCollectionView.alpha = 0.0
            dailyTableView.alpha = 0.0
        }
    }
}

// MARK: - Factory method
extension WeatherViewController {
    static func make(
        viewModel: WeatherViewControllerViewModel,
        cardViewModel: CurrentWeatherCardViewModel
    ) -> WeatherViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: WeatherViewController.storyboardIdentifier
        ) { coder in
            WeatherViewController(
                viewModel: viewModel,
                cardViewModel: cardViewModel,
                coder: coder
            )
        }

        return viewController
    }
}
