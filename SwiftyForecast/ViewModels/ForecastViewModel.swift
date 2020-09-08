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
  var onFailure: ((Error) -> Void)? { get set }
  
  init(repository: Repository, dataAccessObject: CityDAO, modelTranslator: ModelTranslator)
  
  func add(at index: Int)
  func city(at index: Int) -> CityDTO?
  func index(of city: CityDTO) -> Int?
  func contentViewController(at index: Int) -> ContentViewController?
  func measuringSystemSwitched(_ sender: SegmentedControl)
  func loadData()
}
