//
//  WeatherViewController.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {
    private struct Style {
        static let tableViewBackgroundColor = UIColor.clear
        static let tableViewSeparatorStyle = UITableViewCell.SeparatorStyle.none
        static let backgroundColor = UIColor.systemBackground
    }

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
        view.backgroundColor = Style.backgroundColor
        hourlyCollectionView.backgroundColor = Style.backgroundColor
        dailyTableView.backgroundColor = Style.tableViewBackgroundColor
        dailyTableView.separatorStyle = Style.tableViewSeparatorStyle
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
            .sink { [self] twentyFourHoursForecastModel in
                hourlyForcecastDataSource.set(data: twentyFourHoursForecastModel)
                hourlyCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$fiveDaysForecastModel
            .receive(on: DispatchQueue.main)
            .sink { [self] fiveDaysForecastModel in
                dailyForecastDataSource.set(data: fiveDaysForecastModel)
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
