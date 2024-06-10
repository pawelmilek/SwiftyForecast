import UIKit
import Combine

final class WeatherViewController: UIViewController {
    private enum Constant {
        static let weekdayCellHeight = CGFloat(53)
        static let hourlyCellsInRow = CGFloat(4)
        static let hourlySizeForItem = CGSize(width: 77, height: 65)
    }

    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var dailyTableView: UITableView!
    private var weatherCardViewController: CurrentWeatherCardViewController!
    private let dailyForecastDataSource = DailyForecastDataSource()
    private let hourlyForcecastDataSource = HourlyForcecastDataSource()
    private let hourlyForecastFlowLayout = HourlyForecastFlowLayout(
        cellsInRow: Constant.hourlyCellsInRow,
        sizeForItem: Constant.hourlySizeForItem
    )
    private var cancellables = Set<AnyCancellable>()
    var viewModel: WeatherViewControllerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            weatherCardViewController = segue.destination as? CurrentWeatherCardViewController
        }
    }

    private func loadData() {
        viewModel?.loadData()
    }

    private func reloadData() {
        viewModel?.reloadData()
    }

    func loadHourlyData() {
        hourlyCollectionView.reloadData()
    }

    func loadDailyData() {
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

// MAKR: - Private - Set view models closures
private extension WeatherViewController {

    func subscriberPublishers() {
        subscribeWeatherPublisher()
        subscriberLoadingAndErrorPublishers()
        subscribeForecastPublishers()
    }

    func subscribeWeatherPublisher() {
        guard let viewModel else { return }

        viewModel.$locationModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] locationModel in
                weatherCardViewController.loadData(at: locationModel)
            }
            .store(in: &cancellables)
    }

    func subscriberLoadingAndErrorPublishers() {
        guard let viewModel else { return }
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
        guard let viewModel else { return }

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
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel?.reloadCurrentLocation()
                self?.weatherCardViewController.reloadCurrentLocation()
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

    static func make(viewModel: WeatherViewControllerViewModel) -> WeatherViewController {
        let viewController = UIViewController.make(WeatherViewController.self, from: .main)
        viewController.viewModel = viewModel
        return viewController
    }

}
