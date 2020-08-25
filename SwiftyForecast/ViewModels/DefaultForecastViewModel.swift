import UIKit
import RealmSwift
import SafariServices

final class DefaultForecastViewModel: ForecastViewModel {
  var contentViewModels: [ContentViewModel] = []
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
    return URL(string: "https://darksky.net/poweredby/")
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
  
  private let service: ForecastService

  init(service: ForecastService) {
    self.service = service
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
    guard let contentViewModel = contentViewModel(at: index) else {
      return nil
    }
    
    let contentViewController = ContentViewController.make(viewModel: contentViewModel)
    contentViewController.pageIndex = index
    return contentViewController
  }
  
  func contentViewModel(at index: Int) -> ContentViewModel? {
    return contentViewModels[safe: index]
  }
  
  func loadData() {
    contentViewModels = []
    insertUserLocationIntoFirstPosition()
    appendOtherLocations()
  }
  
  private func insertUserLocationIntoFirstPosition() {
    guard !isLoadingData else { return }
    isLoadingData = true
    
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }
      self.isLoadingData = false
      
      switch result {
      case .success(let placemark):
        let city = try! City.add(from: placemark, withId: 0)
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) GeocodeCurrentLocation: \(city)")
        
        let currentLocationViewModel = DefaultContentViewModel(city: city, service: self.service)
        self.contentViewModels.insert(currentLocationViewModel, at: 0)
        self.appendOtherLocations()
        
        self.onSuccess?()
        
      case .failure(let error):
        self.onFailure?(error)
      }
    }
  }
  
  private func appendOtherLocations() {
    let cityArray = Array(cities.filter({ $0.isUserLocation == false }))
    let viewModels = cityArray.map { DefaultContentViewModel(city: $0, service: self.service) }
    contentViewModels.append(contentsOf: viewModels)
  }
  
  func measuringSystemSwitched(_ sender: SegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }
  
}
