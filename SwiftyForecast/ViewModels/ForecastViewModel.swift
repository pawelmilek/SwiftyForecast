import UIKit

protocol ForecastViewModel {
  var contentViewModels: [ContentViewModel] { get set }
  var pendingIndex: Int? { get set }
  var currentIndex: Int { get set }
  var numberOfCities: Int { get }
  
  var onIndexUpdate: ((Int) -> Void)? { get set }
  var onLoadingStatus: ((Bool) -> Void)? { get set }
  var onSuccess: (() -> Void)? { get set }
  var onFailure: ((Error) -> Void)? { get set }
  
  func city(at index: Int) -> City?
  func index(of city: City) -> Int?
  func contentViewModel(at index: Int) -> ContentViewModel?
  func contentViewController(at index: Int) -> ContentViewController?
  func measuringSystemSwitched(_ sender: SegmentedControl)
  
  func loadData()
  
  init(service: ForecastService)
}
