import UIKit

protocol ForecastViewModel {
  var pendingIndex: Int? { get set }
  var currentIndex: Int { get set }
  var numberOfCities: Int { get }
  var powerByURL: URL? { get }
  var currentVisibleViewControllers: [UIViewController] { get }
  
  var onIndexUpdate: ((Int) -> Void)? { get set }
  var onLoadingStatus: ((Bool) -> Void)? { get set }
  var onSuccess: (() -> Void)? { get set }
  
  init(repository: Repository, cityDataAccessObject: CityDAO, forecastDataAccessObject: ForecastDAO, modelTranslator: ModelTranslator)
  
  func addContentViewModel(at index: Int)
  func removeContentViewModel(with location: LocationDTO)
  func city(at index: Int) -> CityDTO?
  func index(of city: CityDTO) -> Int?
  func contentViewController(at index: Int) -> ContentViewController?
  func measuringSystemSwitched(_ sender: SegmentedControl)
  func showOrHideLocationServicesPrompt(at navigationController: UINavigationController)
  func loadAllData()
  func loadData(at index: Int)
}
