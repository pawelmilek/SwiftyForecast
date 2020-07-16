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
    try! City.fetchAll()
  }

  private var isCurrentLocationPage: Bool {
    return currentIndex == 0
  }
  
  private let service: ForecastService

  init(service: ForecastService) {
    self.service = service
  }
  
  func city(at index: Int) -> City? {
    let city = cities.filter("index = %@", index).first
    return city
  }
  
  func index(of city: City) -> Int? {
    let city = cities.filter("index = %@", city.index).first
    return city?.index
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
    if isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled {
      geocodeCurrentLocation()
    } else {
      
    }
  }
  
  private func geocodeCurrentLocation() {
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }
//      self.isLoadingData = true
      
      switch result {
      case .success(let placemark):
        let city = try! City.add(from: placemark, at: self.currentIndex)
        debugPrint("GeocodeCurrentLocation: \(city)")
        let currentLocationViewModel = DefaultContentViewModel(city: city, service: self.service)
        self.contentViewModels.append(currentLocationViewModel)
        self.onSuccess?()
        
      case .failure(let error):
        self.onFailure?(error)
      }
      
//      self.isLoadingData = false
    }
  }
  
  func measuringSystemSwitched(_ sender: SegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }
  
}
