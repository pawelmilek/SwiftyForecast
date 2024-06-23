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
    private lazy var cardViewController: WeatherCardViewController = {
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
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("File: \(#file), Function: \(#function), line: \(#line)")
    }

    private func loadData() {
        Task {
            await self.viewModel.loadData()
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
        self.addChild(cardViewController)
        cardViewController.view.frame = cardView.frame
        cardView.addSubview(cardViewController.view)
        cardViewController.didMove(toParent: self)
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
        viewModel.$twentyFourHoursForecastModel
            .receive(on: DispatchQueue.main)
            .map {
                $0.map {
                    HourlyViewCellViewModel(
                        model: $0,
                        temperatureFormatterFactory: TemperatureFormatterFactory(
                            notationStorage: NotationSettingsStorage()
                        )
                    )
                }
            }
            .sink { [self] hourlyViewModels in
                hourlyForcecastDataSource.set(viewModels: hourlyViewModels)
                hourlyCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$fiveDaysForecastModel
            .receive(on: DispatchQueue.main)
            .map {
                $0.map {
                    DailyViewCellViewModel(
                        model: $0,
                        temperatureFormatterFactory: TemperatureFormatterFactory(
                            notationStorage: NotationSettingsStorage()
                        )
                    )
                }
            }
            .sink { [self] dailyViewModels in
                dailyForecastDataSource.set(viewModeles: dailyViewModels)
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

    func loadForecastData() {
        Task {
            await viewModel.loadData()
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
