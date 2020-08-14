import RealmSwift
import MapKit

final class DefaultCityListViewModel: CityListViewModel {
  var numberOfCities: Int {
    return cityViewModels.count
  }
  
  private var cities: Results<City> {
    let allCities = try! City.fetchAll()
    return allCities.sorted(byKeyPath: "index", ascending: true)
  }
  
  private lazy var cityViewModels: [CityViewModel] = {
    return cities.map { DefaultCityViewModel(city: $0) }
  }()

  weak var delegate: CityListViewModelDelegate?
  
  init(delegate: CityListViewModelDelegate) {
    self.delegate = delegate
  }
  
  func delete(at indexPath: IndexPath) {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) delete city")
  }

  func select(at index: Int) {
    guard let selectedCity = cities.filter("index = %@", index).first else { return }
    delegate?.didSelect(self, city: selectedCity)
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

}
