import UIKit

final class ContentViewController: UIViewController {
  @IBOutlet private weak var forecastView: ForecastView!
  @IBOutlet private weak var weekdaysTableView: UITableView!
  
  private var dailyForecastTableViewBottomConstraint: NSLayoutConstraint?
  private var forecastViewMoreDetailsViewBottomConstraint: NSLayoutConstraint?
  private var forecastViewStackViewBottomToMoreDetailsBottomConstraint: NSLayoutConstraint?
  private var forecastViewStackViewBottomToSafeAreaBottomConstraint: NSLayoutConstraint?
  
  var pageIndex: Int {
    get {
      return viewModel?.pageIndex ?? 0
    }
    
    set {
      viewModel?.pageIndex = newValue
    }
  }
  
  var viewModel: ContentViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchForecast()
  }
  
  deinit {
    removeNotificationObservers()
  }
}

// MARK: - Private - SetUps
private extension ContentViewController {
  
  func setUp() {
    setupAppearance()
    setForecastViewDelegate()
    setupWeekTableView()
    arrangeConstraints()
    setViewModelClosureCallbacks()
    addNotificationObservers()
  }
  
}

// MARK: - Private - Setups
private extension ContentViewController {
  
  func setForecastViewDelegate() {
    forecastView.delegate = self
  }
  
  func setupWeekTableView() {
    weekdaysTableView.register(cellClass: DailyTableViewCell.self)
    weekdaysTableView.dataSource = self
    weekdaysTableView.delegate = self
    weekdaysTableView.showsVerticalScrollIndicator = false
    weekdaysTableView.allowsSelection = false
    weekdaysTableView.rowHeight = UITableView.automaticDimension
    weekdaysTableView.estimatedRowHeight = 85
    weekdaysTableView.tableFooterView = UIView()
  }
  
  func arrangeConstraints() {
    forecastViewMoreDetailsViewBottomConstraint = forecastView.moreDetailsViewBottomConstraint
    forecastViewStackViewBottomToMoreDetailsBottomConstraint = forecastView.stackViewBottomToMoreDetailsTopConstraint
    forecastViewStackViewBottomToSafeAreaBottomConstraint = forecastView.stackViewBottomToSafeAreaBottomConstraint
    dailyForecastTableViewBottomConstraint = forecastView.bottomAnchor.constraint(equalTo: weekdaysTableView.bottomAnchor,
                                                                                  constant: 0)
  }
  
  func setupAppearance() {
    view.backgroundColor = Style.ContentForecast.backgroundColor
    weekdaysTableView.backgroundColor = Style.ContentForecast.tableViewBackgroundColor
    weekdaysTableView.separatorStyle = Style.ContentForecast.tableViewSeparatorStyle
  }
  
}

// MARK: - Private - Add notification center
private extension ContentViewController {
  
  func addNotificationObservers() {
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(unitNotationDidChange),
                                   for: .unitNotationDidChange)
  }
  
  func removeNotificationObservers() {
    ForecastNotificationCenter.remove(observer: self)
  }
  
}

// MAKR: - Private - Set view models closures
private extension ContentViewController {
  
  func setViewModelClosureCallbacks() {
    viewModel?.onSuccess = { [weak self] in
      self?.reloadData()
    }
    
    viewModel?.onFailure = { error in
      DispatchQueue.main.async {
        (error as? ErrorHandleable)?.handler()
      }
    }
    
    viewModel?.onLoadingStatus = { isLoading in
      if isLoading {
        ActivityIndicatorView.shared.startAnimating()
      } else {
        ActivityIndicatorView.shared.stopAnimating()
      }
    }
  }
  
}

// MAKR: - Private - Fetch weather forecast
private extension ContentViewController {
  
  func fetchForecast() {
    viewModel?.loadData()
  }
  
}

// MARK: - ForecastViewDelegate protocol
extension ContentViewController: ForecastViewDelegate {
  
  func currentForecastDidExpand() {
    animateBouncingEffect()
    
    forecastViewMoreDetailsViewBottomConstraint?.constant = 0
    dailyForecastTableViewBottomConstraint?.isActive = true
    forecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = false
    forecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = true
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.forecastView.animateLabelsScaling()
                    self.view.layoutIfNeeded()
                    self.impactFeedback(style: .soft)
                   }, completion: { isFinished in
                    guard isFinished else { return }
                    AppStoreReviewNotifier.notify(.detailsInteractionExpanded)
                   })
  }
  
  func currentForecastDidCollapse() {
    let height = forecastView.frame.size.height
    
    forecastViewMoreDetailsViewBottomConstraint?.constant = height
    dailyForecastTableViewBottomConstraint?.isActive = false
    forecastViewStackViewBottomToSafeAreaBottomConstraint?.isActive = true
    forecastViewStackViewBottomToMoreDetailsBottomConstraint?.isActive = false
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseIn,
                   animations: {
                    self.forecastView.animateLabelsIdentity()
                    self.view.layoutIfNeeded()
                    self.impactFeedback(style: .soft)
    })
  }
  
}

// MARK: - Private - Animate bouncing effect and haptic feedback
private extension ContentViewController {
  
  func animateBouncingEffect() {
    forecastView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    UIView.animate(withDuration: 1.8,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 6.0,
                   options: .allowUserInteraction,
                   animations: {
      self.forecastView.transform = .identity
    })
  }
  
  func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
  }
  
  func selectionFeedback() {
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    selectionFeedbackGenerator.selectionChanged()
  }

}

// MARK: - UITableViewDataSource protcol
extension ContentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfDays ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dailyItems = viewModel?.sevenDaysData,
      let item = dailyItems[safe: indexPath.row] else { return UITableViewCell() }
    
    let viewModel = DefaultDailyCellViewModel(dailyData: item)
    let cell = tableView.dequeueCell(DailyTableViewCell.self, for: indexPath)
    cell.configure(by: viewModel)
    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension ContentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
}

// MARK: - Actions
extension ContentViewController {
  
  @objc func unitNotationDidChange(_ notification: NSNotification) {
    guard let segmentedControl = notification.userInfo?[NotificationCenterUserInfo.segmentedControlChanged.key] as? SegmentedControl else { return }
    guard let unitNotation = UnitNotation(rawValue: segmentedControl.selectedIndex) else { return }
    guard let temperatureNotation = TemperatureNotation(rawValue: segmentedControl.selectedIndex) else { return }

    let notationController = NotationController()
    notationController.unitNotation = unitNotation
    notationController.temperatureNotation = temperatureNotation
    selectionFeedback()
    reloadData()
  }
  
  private func reloadData() {
    guard let viewModel = viewModel else { return }
    
    DispatchQueue.main.async { [weak self] in
      self?.forecastView.configure(by: viewModel)
      self?.weekdaysTableView.reloadData()
    }
  }
  
}

// MARK: - Factory method
extension ContentViewController {
  
  static func make(viewModel: ContentViewModel) -> ContentViewController {
    let viewController = StoryboardViewControllerFactory.make(ContentViewController.self, from: .main)
    viewController.viewModel = viewModel
    return viewController
  }
  
}
