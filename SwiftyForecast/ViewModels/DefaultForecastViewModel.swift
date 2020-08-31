import UIKit
import RealmSwift
import SafariServices

final class DefaultForecastViewModel: ForecastViewModel {
  var pendingIndex: Int?
  var currentIndex: Int = 0 {
    didSet {
      onIndexUpdate?(currentIndex)
    }
  }
  
  var numberOfCities: Int {
    cities.count
  }
  
  var powerByURL: URL? {
    URL(string: "https://darksky.net/poweredby/")
  }

  var currentVisibleViewControllers: [UIViewController] {
    guard let visibleViewController = contentViewController(at: currentIndex) else { return [] }
    return [visibleViewController]
  }
  
  var onIndexUpdate: ((Int) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  var onSuccess: (() -> Void)?
  var onFailure: ((Error) -> Void)?
  
  private var isLoadingData = false {
     didSet {
       onLoadingStatus?(isLoadingData)
     }
   }
  
  private var cities: Results<City> {
    try! City.fetchAllOrdered()
  }

  private var isUserLocationPage: Bool {
    return currentIndex == 0
  }

  private var contentViewModels: [ContentViewModel] = []
  private let repository: Repository

  init(repository: Repository) {
    self.repository = repository
  }
  
  func city(at index: Int) -> City? {
    let city = Array(cities)[safe: index]
    return city
  }
  
  func index(of city: City) -> Int? {
    let index = cities.index(of: city)
    return index
  }
  
  func contentViewController(at index: Int) -> ContentViewController? {
    guard let contentViewModel = contentViewModels[safe: index] else {
      return nil
    }
    
    let contentViewController = ContentViewController.make(viewModel: contentViewModel)
    contentViewController.pageIndex = index
    return contentViewController
  }
  
  func loadData() {
    loadUserLocationData {
      self.appendOtherLocations()
      self.onSuccess?()
    }
  }
  
  private func loadUserLocationData(completion: @escaping () -> Void) {
    guard !isLoadingData else { return }
    isLoadingData = true
    
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }
      self.isLoadingData = false
      
      switch result {
      case .success(let placemark):
        let city = try! City.add(from: placemark, withId: 1)
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) GeocodeCurrentLocation: \(city)")
        
        let viewModel = DefaultContentViewModel(city: city, repository: self.repository)
        self.contentViewModels.insert(viewModel, at: 0)
        completion()
        
      case .failure(let error):
        self.onFailure?(error)
      }
    }
  }
  
  private func appendOtherLocations() {
    let cityArray = Array(cities.filter { $0.isUserLocation == false })
    let viewModels = cityArray.map { DefaultContentViewModel(city: $0, repository: self.repository) }
    
    debugPrint("\(cityArray)")
    
    for viewModel in viewModels {
      if contentViewModels.contains(where: {
        debugPrint("contentViewModels: \($0.cityName)")
        debugPrint("viewModel: \(viewModel.cityName)")
        return $0.cityName == viewModel.cityName
      }) == false {
        contentViewModels.append(contentsOf: viewModels)
      }
    }
  }
  
  func measuringSystemSwitched(_ sender: SegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }
  
}
