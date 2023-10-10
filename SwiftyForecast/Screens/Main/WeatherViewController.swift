import UIKit
import Combine

final class WeatherViewController: UIViewController {
    private enum Constant {
        static let weekdaysTableViewEstimatedRowHeight = CGFloat(85)
        static let weekdaysTableViewHeightForRowAtIndexPath = CGFloat(40)
    }

    @IBOutlet private weak var currentWeatherView: CurrentWeatherView!
    @IBOutlet private weak var weekdaysTableView: UITableView!

    var viewModel: CurrentWeatherView.ViewModel?
    var hourlyForecastViewModel: HourlyForecastViewModel?
    var dailyForecastViewModel: DailyForecastViewModel?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func loadData() {
        viewModel?.loadData()
    }

    private func reloadData() {
        viewModel?.reloadData()
    }

    func temperatureNotationSystemDidChange(_ sender: SegmentedControl) {
        viewModel?.onSegmentedControlChange(sender)
    }
}

// MARK: - Private - Setup
private extension WeatherViewController {

    func setup() {
        currentWeatherView.delegate = self
        setupAppearance()
        setupWeekTableView()
        subscriberToViewModel()
    }

}

// MARK: - Private - Setups
private extension WeatherViewController {

    func setupAppearance() {
        view.backgroundColor = Style.Weather.backgroundColor
        weekdaysTableView.backgroundColor = Style.Weather.tableViewBackgroundColor
        weekdaysTableView.separatorStyle = Style.Weather.tableViewSeparatorStyle
    }

    func setupWeekTableView() {
        weekdaysTableView.register(cellClass: DailyViewCell.self)
        weekdaysTableView.dataSource = self
        weekdaysTableView.delegate = self
        weekdaysTableView.showsVerticalScrollIndicator = false
        weekdaysTableView.allowsSelection = false
        weekdaysTableView.rowHeight = UITableView.automaticDimension
        weekdaysTableView.estimatedRowHeight = Constant.weekdaysTableViewEstimatedRowHeight
        weekdaysTableView.tableFooterView = UIView()
    }

}

// MAKR: - Private - Set view models closures
private extension WeatherViewController {

    func subscriberToViewModel() {
        loadingIndicatorSubscriber()
        errorSubscriber()
        measurementSystemSubscriber()
        weekdayAndLocationSubscriber()
        iconAndDescriptionSubscriber()
        temperatureSubscriber()
        conditionsSubscriber()
        hourlyForecastSubscriber()
        dailyForecastSubscriber()
    }

    func loadingIndicatorSubscriber() {
        viewModel?.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    ActivityIndicatorView.shared.startAnimating()
                } else {
                    ActivityIndicatorView.shared.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    func errorSubscriber() {
        viewModel?.$error
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

    func measurementSystemSubscriber() {
        guard let viewModel else { return }
        Publishers.Zip(
            viewModel.$measurementSystem,
            viewModel.$temperatureNotation
        )
        .sink { [self] _ in
            reloadData()
        }
        .store(in: &cancellables)
    }

    func weekdayAndLocationSubscriber() {
        guard let viewModel else { return }
        viewModel.$weekdayMonthDay
            .assign(to: \.text!, on: currentWeatherView.dateLabel)
            .store(in: &cancellables)

        viewModel.$locationName
            .assign(to: \.text!, on: currentWeatherView.locationName)
            .store(in: &cancellables)
    }

    func iconAndDescriptionSubscriber() {
        guard let viewModel else { return }

        viewModel.$icon
            .assign(to: \.image, on: currentWeatherView.iconImageView)
            .store(in: &cancellables)
        viewModel.$description
            .assign(to: \.text!, on: currentWeatherView.conditionDescription)
            .store(in: &cancellables)
        viewModel.$dayNight
            .assign(to: \.text!, on: currentWeatherView.dayNightLabel)
            .store(in: &cancellables)
    }

    func temperatureSubscriber() {
        guard let viewModel else { return }
        viewModel.$temperature
            .assign(to: \.text!, on: currentWeatherView.temperatureLabel)
            .store(in: &cancellables)
        viewModel.$temperatureMaxMin
            .assign(to: \.text!, on: currentWeatherView.temperatureMaxMinLabel)
            .store(in: &cancellables)
    }

    func conditionsSubscriber() {
        guard let viewModel else { return }
        Publishers.CombineLatest4(
            viewModel.$sunriseSymbol,
            viewModel.$sunriseTime,
            viewModel.$sunsetSymbol,
            viewModel.$sunsetTime
        )
        .sink { [self] newValue in
            currentWeatherView.sunriseView.configure(symbol: newValue.0, value: newValue.1)
            currentWeatherView.sunsetView.configure(symbol: newValue.2, value: newValue.3)
        }
        .store(in: &cancellables)

        Publishers.CombineLatest4(
            viewModel.$windSpeedSymbol,
            viewModel.$windSpeed,
            viewModel.$humiditySymbol,
            viewModel.$humidity
        )
        .sink { [self] newValue in
            currentWeatherView.windView.configure(symbol: newValue.0, value: newValue.1)
            currentWeatherView.humidityView.configure(symbol: newValue.2, value: newValue.3)
        }
        .store(in: &cancellables)
    }

    func hourlyForecastSubscriber() {
        viewModel?.$isTwentyFourHoursForecastLoaded
            .sink { [self] newValue in
                guard let viewModel, newValue == true else { return }
                hourlyForecastViewModel = HourlyForecastViewModel(
                    models: viewModel.twentyFourHoursForecastModel
                )
                currentWeatherView.loadHourlyData()
            }
            .store(in: &cancellables)
    }

    func dailyForecastSubscriber() {
        viewModel?.$isFiveDaysForecastLoaded
            .sink { [self] newValue in
                guard let viewModel, newValue == true else { return }
                dailyForecastViewModel = DailyForecastViewModel(
                    models: viewModel.fiveDaysForecastModel
                )
                weekdaysTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource protcol
extension WeatherViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecastViewModel?.numberOfItems ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyViewCell.reuseIdentifier,
            for: indexPath
        ) as? DailyViewCell else { return UITableViewCell() }

        guard let dailyForecastViewModel,
              let item = dailyForecastViewModel.dailyItem(at: indexPath) else { return cell }

        cell.dateLabel.attributedText = item.attributedDate
        cell.iconImageView.kf.setImage(with: item.iconURL)
        cell.temperatureLabel.text = item.temperature
        return cell
    }

}

// MARK: - UITableViewDelegate protocol
extension WeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.weekdaysTableViewHeightForRowAtIndexPath
    }

}

// MARK: - CurrentWeatherViewDelegate
extension WeatherViewController: CurrentWeatherViewDelegate {

    func currentWeatherView(
        _ view: CurrentWeatherView,
        numberOfHourlyItemsInSection section: Int
    ) -> Int {
        hourlyForecastViewModel?.numberOfItems ?? 0
    }

    func currentWeatherView(
        _ view: CurrentWeatherView,
        hourlyDataForItemAt indexPath: IndexPath
    ) -> HourlyForecastData? {
        guard let hourlyForecastViewModel else { return nil }
        return hourlyForecastViewModel.hourlyItem(at: indexPath)
    }

}

// MARK: - Factory method
extension WeatherViewController {

    static func make(viewModel: CurrentWeatherView.ViewModel) -> WeatherViewController {
        let viewController = UIViewController.make(WeatherViewController.self, from: .main)
        viewController.viewModel = viewModel
        return viewController
    }

}
