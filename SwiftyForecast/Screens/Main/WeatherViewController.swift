import UIKit
import Combine

final class WeatherViewController: UIViewController {
    private enum Constant {
        static let weekdaysTableViewHeightForRowAtIndexPath = CGFloat(50)
        static let numberOfHourlyCellsInRow = CGFloat(4)
        static let hourlySizeForItem = CGSize(width: 77, height: 65)
        static let hourlyInsetForSection = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        static let hourlyMinimumLineSpacingForSection = CGFloat(10)
    }

    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var dailyTableView: UITableView!
    private var weatherCardViewController: CurrentWeatherCardViewController!

    var viewModel: ViewModel?
    private var dailyForecastViewModels: [DailyViewCell.ViewModel] = []
    private var hourlyForecastViewModels: [HourlyViewCell.ViewModel] = []

    private var cancellables = Set<AnyCancellable>()

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
        subscriberToViewModel()
        subscribeToNotificationCenterPublisher()
    }

    func setupAppearance() {
        view.backgroundColor = Style.Weather.backgroundColor
        hourlyCollectionView.backgroundColor = Style.Weather.backgroundColor
        dailyTableView.backgroundColor = Style.Weather.tableViewBackgroundColor
        dailyTableView.separatorStyle = Style.Weather.tableViewSeparatorStyle
    }

    func setupHourlyCollectionView() {
        hourlyCollectionView.register(cellClass: HourlyViewCell.self)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        hourlyCollectionView.showsVerticalScrollIndicator = false
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        hourlyCollectionView.contentInsetAdjustmentBehavior = .never
    }

    func setupWeekTableView() {
        dailyTableView.register(cellClass: DailyViewCell.self)
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.allowsSelection = false
        dailyTableView.rowHeight = UITableView.automaticDimension
        dailyTableView.tableFooterView = UIView()
    }
}

// MAKR: - Private - Set view models closures
private extension WeatherViewController {

    func subscriberToViewModel() {
        subscribeToWeatherPublisher()
        subscriberToLoadingAndErrorPublisher()
        subscribeToForecastPublisher()
    }

    func subscribeToWeatherPublisher() {
        guard let viewModel else { return }

        viewModel.$locationModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [self] locationModel in
                weatherCardViewController.loadData(at: locationModel)
            }
            .store(in: &cancellables)
    }

    func subscriberToLoadingAndErrorPublisher() {
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
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error as? ErrorPresentable {
                    error.present()
                } else if let error {
                    AlertViewPresenter.shared.presentError(withMessage: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }

    func subscribeToForecastPublisher() {
        guard let viewModel else { return }

        viewModel.$twentyFourHoursForecastModel
            .combineLatest(viewModel.$fiveDaysForecastModel)
            .receive(on: DispatchQueue.main)
            .map { ($0.0.map { HourlyViewCell.ViewModel(model: $0) }, $0.1.map { DailyViewCell.ViewModel(model: $0) }) }
            .sink { [self] (hourlyViewModels, dailyViewModels) in
                hourlyForecastViewModels = hourlyViewModels
                dailyForecastViewModels = dailyViewModels

                loadHourlyData()
                loadDailyData()
            }
            .store(in: &cancellables)
    }

    func subscribeToNotificationCenterPublisher() {
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
        UIView.animate(withDuration: 0.3) { [self] in
            hourlyCollectionView.alpha = 1.0
            dailyTableView.alpha = 1.0
        }
    }

    func hideContent() {
        UIView.animate(withDuration: 0.3) { [self] in
            hourlyCollectionView.alpha = 0.0
            dailyTableView.alpha = 0.0
        }
    }
}

// MARK: - UICollectionViewDataSource protocol
extension WeatherViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyForecastViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyViewCell.reuseIdentifier,
            for: indexPath
        ) as? HourlyViewCell else {
            return HourlyViewCell()
        }

        guard !hourlyForecastViewModels.isEmpty else { return cell }

        let item = hourlyForecastViewModels[indexPath.row]
        cell.iconImageView.kf.setImage(with: item.iconURL)
        cell.timeLabel.text = item.time
        cell.temperatureLabel.text = item.temperature
        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout protocol
extension WeatherViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return Constant.hourlySizeForItem
        }

        let sectionInsetLeftAndRightSum = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let numberOfHorizontalSpacing = Constant.numberOfHourlyCellsInRow - 1
        let minimumLineSpacing = flowLayout.minimumLineSpacing

        let collectionViewWidth = collectionView.frame.size.width
        let totalAvailableSpace = sectionInsetLeftAndRightSum + (minimumLineSpacing * numberOfHorizontalSpacing)

        let width = (collectionViewWidth - totalAvailableSpace) / Constant.numberOfHourlyCellsInRow
        return CGSize(width: width, height: Constant.hourlySizeForItem.height)
    }

}

// MARK: - UITableViewDataSource protcol
extension WeatherViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecastViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyViewCell.reuseIdentifier,
            for: indexPath
        ) as? DailyViewCell else { return UITableViewCell() }

        guard !dailyForecastViewModels.isEmpty else { return cell }

        let viewModel = dailyForecastViewModels[indexPath.row]
        cell.iconImageView.kf.setImage(with: viewModel.iconURL)
        cell.dateLabel.attributedText = viewModel.attributedDate
        cell.temperatureLabel.text = viewModel.temperature
        return cell
    }

}

// MARK: - UITableViewDelegate protocol
extension WeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.weekdaysTableViewHeightForRowAtIndexPath
    }

}

// MARK: - Factory method
extension WeatherViewController {

    static func make(viewModel: ViewModel) -> WeatherViewController {
        let viewController = UIViewController.make(WeatherViewController.self, from: .main)
        viewController.viewModel = viewModel
        return viewController
    }

}
