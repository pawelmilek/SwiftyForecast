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
    allCities.count
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
  
  private var allCities: [CityDTO] {
    return dataAccessObject.getAll().compactMap { modelTranslator.translate($0) }
  }

  private var isUserLocationPage: Bool {
    return currentIndex == 0
  }

  private var contentViewModels: [ContentViewModel] = []
  private let repository: Repository
  private let dataAccessObject: CityDAO
  private let modelTranslator: ModelTranslator

  init(repository: Repository,
       dataAccessObject: CityDAO = DefaultCityDAO(),
       modelTranslator: ModelTranslator = ModelTranslator()) {
    self.repository = repository
    self.dataAccessObject = dataAccessObject
    self.modelTranslator = modelTranslator
  }
  
  func add(at index: Int) {
    guard let newlyAddedCity = city(at: index) else { return }
    let viewModel = DefaultContentViewModel(city: newlyAddedCity, repository: self.repository)
    
    if !checkIfExists(viewModel) {
      contentViewModels.append(viewModel)
    }
  }
  
  func city(at index: Int) -> CityDTO? {
    let city = allCities[safe: index]
    return city
  }
  
  func index(of city: CityDTO) -> Int? {
    let index = allCities.firstIndex(where: { $0.id == city.id })
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
        let city = City(placemark: placemark)
        self.dataAccessObject.put(city, id: 1)
        let addedCity = self.modelTranslator.translate(city)!
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) GeocodeCurrentLocation: \(city)")
        
        let viewModel = DefaultContentViewModel(city: addedCity, repository: self.repository)
        self.contentViewModels.insert(viewModel, at: 0)
        completion()
        
      case .failure(let error):
        self.onFailure?(error)
      }
    }
  }
  
  private func appendOtherLocations() {
    let cityArray = allCities.filter { $0.isUserLocation == false }
    let viewModels = cityArray.map { DefaultContentViewModel(city: $0, repository: self.repository) }
    
    debugPrint("\(cityArray)")
    
    for viewModel in viewModels {
      if !checkIfExists(viewModel) {
        contentViewModels.append(contentsOf: viewModels)
      }
    }
  }
  
  func checkIfExists(_ contentViewModel: ContentViewModel) -> Bool {
    return contentViewModels.contains(where: { return $0.cityName == contentViewModel.cityName })
  }
  
  
  func measuringSystemSwitched(_ sender: SegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }
  
}
