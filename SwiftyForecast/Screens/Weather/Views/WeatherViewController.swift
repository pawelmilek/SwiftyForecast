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
    private lazy var weatherCardViewController: WeatherCardViewController = {
        let viewController = WeatherCardViewController(viewModel: cardViewModel)
        return viewController
    }()

    private let dailyForecastDataSource = DailyForecastDataSource()
    private let hourlyForcecastDataSource = HourlyForcecastDataSource()
    private let hourlyForecastFlowLayout = HourlyForecastFlowLayout(
        cellsInRow: Constant.hourlyCellsInRow,
        sizeForItem: Constant.hourlySizeForItem
    )
    private var cancellables = Set<AnyCancellable>()
    let viewModel: WeatherViewControllerViewModel
    private let cardViewModel: WeatherCardViewViewModel

    init?(
        viewModel: WeatherViewControllerViewModel,
        cardViewModel: WeatherCardViewViewModel,
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
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadForecastDataWithAnimation()
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }

    private func loadForecastDataWithAnimation() {
        Task {
            defer { showContent() }
            hideContent()
            await viewModel.loadData()
        }
    }
}

// MARK: - Private - Setup
private extension WeatherViewController {

    func setup() {
        addChildWeatherCardViewController()
        setupAppearance()
        setupHourlyCollectionView()
        setupWeekTableView()
        subscriberPublishers()
    }

    private func addChildWeatherCardViewController() {
        self.addChild(weatherCardViewController)
        weatherCardViewController.view.frame = cardView.frame
        cardView.addSubview(weatherCardViewController.view)
        weatherCardViewController.didMove(toParent: self)
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
        subscribeNotificationCenterPublisher()

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
            .sink { [self] hourlyViewModels, dailyViewModels in
                hourlyForcecastDataSource.set(viewModels: hourlyViewModels)
                dailyForecastDataSource.set(viewModeles: dailyViewModels)

                hourlyCollectionView.reloadData()
                dailyTableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { error in
                debugPrint(error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    func subscribeNotificationCenterPublisher() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadForecastData()
            }
            .store(in: &cancellables)
    }

    func loadForecastData() {
        Task {
            await viewModel.loadData()
        }
    }

    func showContent() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [self] in
//            hourlyCollectionView.alpha = 1.0
//            dailyTableView.alpha = 1.0
        }
    }

    func hideContent() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
//            hourlyCollectionView.alpha = 0.0
//            dailyTableView.alpha = 0.0
        }
    }
}

// MARK: - Factory method
extension WeatherViewController {
    static func make(
        viewModel: WeatherViewControllerViewModel,
        cardViewModel: WeatherCardViewViewModel
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
