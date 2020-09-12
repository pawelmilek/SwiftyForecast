import RealmSwift
import MapKit

final class DefaultCityListViewModel: CityListViewModel {
  var numberOfCities: Int {
    return cityViewModels.count
  }
  
  var onCitySelected: ((Int) -> Void)?
  var onInitialDataLoad: (() -> Void)?
  var onApplyListChanges: ((_ deletions: [Int], _ insertions: [Int], _ updates: [Int]) -> Void)?
  
  private var citiesToken: NotificationToken?

  private var cities: Results<City>? {
    return cityDAO.getAll()
  }

  private var cityViewModels: [CityViewModel] {
    guard let cities = cities else { return [] }
    return cities.map { DefaultCityViewModel(city: $0) }
  }
  
  private let cityDAO: CityDAO
  private let forecastDAO: ForecastDAO
  
  init(cityDAO: CityDAO = DefaultCityDAO(), forecastDAO: ForecastDAO = DefaultForecastDAO()) {
    self.cityDAO = cityDAO
    self.forecastDAO = forecastDAO
    
    citiesToken = cities?.observe { changes in
      switch changes {
      case .initial:
        self.onInitialDataLoad?()
        
      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
        self.onApplyListChanges?(deletions, insertions, modifications)
        debugPrint("deletions: \(deletions)")
        debugPrint("insertions: \(insertions)")
         debugPrint("modifications: \(modifications)")
        
      case .error(let error):
        debugPrint(error)
      }
    }
  }
  
  func name(at index: Int) -> String {
    return cityViewModels[safe: index]?.name ?? InvalidReference.notApplicable
  }
  
  func localTime(at index: Int) -> String {
    return cityViewModels[safe: index]?.localTime ?? InvalidReference.notApplicable
  }
  
  func map(at index: Int) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
    return cityViewModels[safe: index]?.map
  }
  
  func relaodData(initialUpdate: @escaping () -> Void,
                  applyChanges: @escaping (_ deletions: [Int], _ insertions: [Int], _ updates: [Int]) -> Void) {

  }
  
  func onViewDeinit() {
    citiesToken?.invalidate()
  }

}

// MARK: - CRUD
extension DefaultCityListViewModel {
  
  func select(at index: Int) {
    guard let cities = cities else { return }
    guard let _ = Array(cities)[safe: index] else { return }
    onCitySelected?(index)
  }
  
  func delete(at indexPath: IndexPath) {
    guard let cities = cities, cities.count >= indexPath.row else { return }
    guard let coordinate = cities[indexPath.row].location?.coordinate else { return }
    guard let forecastResponse = forecastDAO.get(latitude: coordinate.latitude, longitude: coordinate.longitude) else { return }

    do {
      let cityToDelete = cities[indexPath.row]
      try cityDAO.delete(cityToDelete)
      try forecastDAO.delete(forecastResponse)

    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) delete city")
    }
  }
  
}
