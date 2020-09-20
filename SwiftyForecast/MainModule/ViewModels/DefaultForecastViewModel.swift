import UIKit
import RealmSwift
import SafariServices

final class DefaultForecastViewModel: ForecastViewModel {
  private static let userLocationPageControlIndex = 0
  private static let userLocationIdentifier = 1
  private let dispatchGroup = DispatchGroup()
  
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
  
  func addContentViewModel(at index: Int) {
    guard let city = city(at: index) else { return }
    let viewModel = DefaultContentViewModel(city: city, repository: self.repository)
    
    if !checkIfExists(viewModel) {
      contentViewModels.append(viewModel)
    }
  }
  
  func removeContentViewModel(with location: LocationDTO) {
    guard let viewModel = contentViewModels.first(where: { $0.location == location }) else { return }
    guard let indexToRemove = contentViewModels.firstIndex(where: { $0.location == viewModel.location }) else { return }
    contentViewModels.remove(at: indexToRemove)
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
    
    let viewController = ContentViewController.make(viewModel: contentViewModel)
    viewController.pageIndex = index
    return viewController
  }
  
  func loadAllData() {
    isLoadingData = true

    for (index, _) in allCities.enumerated() {
      if index == DefaultForecastViewModel.userLocationPageControlIndex {
        loadUserLocationDataAsync(dispatchGroup: dispatchGroup)
      } else {
        addContentViewModelAsync(dispatchGroup: dispatchGroup, at: index)
      }
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.isLoadingData = false
      self?.onSuccess?()
    }
  }
  
  func loadData(at index: Int) {
    if index == DefaultForecastViewModel.userLocationPageControlIndex {
      loadUserLocationData()
    } else {
      addContentViewModel(at: index)
    }
  }
  
  func measuringSystemSwitched(_ sender: SegmentedControl) {
    ForecastNotificationCenter.post(.unitNotationDidChange,
                                    object: nil,
                                    userInfo: [NotificationCenterUserInfo.segmentedControlChanged.key: sender])
  }
  
}

// MARK: - Private - Load data
private extension DefaultForecastViewModel {
  
  func loadUserLocationData() {
    guard !isLoadingData else { return }
    isLoadingData = true
    
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }
      self.isLoadingData = false
      
      switch result {
      case .success(let placemark):
        let city = City(placemark: placemark, isUserLocation: true)
        self.insertIntoDatabase(city: city)
        self.makeContentViewModel(by: city)

        debugPrint("File: \(#file), Function: \(#function), line: \(#line) GeocodeCurrentLocation: \(city)")
        self.onSuccess?()
        
      case .failure(let error):
        self.onFailure?(error)
      }
    }
  }
  
}

// MARK: - Private - Load data async
private extension DefaultForecastViewModel {
  
  func loadUserLocationDataAsync(dispatchGroup: DispatchGroup) {
    dispatchGroup.enter()
    var successCounterToPreventMultipleExecution = 0
    
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }

      defer {
        if successCounterToPreventMultipleExecution <= 1 {
          dispatchGroup.leave()
        }
      }
      
      switch result {
      case .success(let placemark):
        let city = City(placemark: placemark, isUserLocation: true)
        self.insertIntoDatabase(city: city)
        self.makeContentViewModel(by: city)
        successCounterToPreventMultipleExecution = successCounterToPreventMultipleExecution + 1
        
      case .failure(let error):
        self.onFailure?(error)
        successCounterToPreventMultipleExecution = 0
      }
    }
  }
  
  func addContentViewModelAsync(dispatchGroup: DispatchGroup, at index: Int) {
    dispatchGroup.enter()
    defer { dispatchGroup.leave() }
    
    guard let city = city(at: index) else { return }
    let viewModel = DefaultContentViewModel(city: city, repository: self.repository)
    
    if !checkIfExists(viewModel) {
      contentViewModels.append(viewModel)
    }
  }
  
}

// MARK: - Private -
private extension DefaultForecastViewModel {
  
  func insertIntoDatabase(city: City) {
    try! dataAccessObject.put(city, id: DefaultForecastViewModel.userLocationIdentifier)
  }
  
  func makeContentViewModel(by city: City) {
    guard let cityDTO = modelTranslator.translate(city) else { return }
    let contentViewModel = DefaultContentViewModel(city: cityDTO, repository: repository)
    addContentViewModelAtUserLocationPage(viewModel: contentViewModel)
  }
  
  func addContentViewModelAtUserLocationPage(viewModel: ContentViewModel) {
    guard !self.checkIfExists(viewModel) else { return }
    contentViewModels.insert(viewModel, at: DefaultForecastViewModel.userLocationPageControlIndex)
  }
  
  func checkIfExists(_ contentViewModel: ContentViewModel) -> Bool {
    return contentViewModels.contains(where: { return $0.cityName == contentViewModel.cityName })
  }
  
}
