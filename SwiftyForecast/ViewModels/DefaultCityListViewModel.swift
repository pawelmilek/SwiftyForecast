import RealmSwift
import MapKit

final class DefaultCityListViewModel: CityListViewModel {
  var numberOfCities: Int {
    return cityViewModels.count
  }
  
  private var cities: Results<City>?
  private var citiesToken: NotificationToken?

  private var cityViewModels: [CityViewModel] {
    guard let cities = cities else { return [] }
    return cities.map { DefaultCityViewModel(city: $0) }
  }

  weak var delegate: CityListViewModelDelegate?

  init(delegate: CityListViewModelDelegate) {
    self.delegate = delegate
  }
  
  func delete(at indexPath: IndexPath) {
    guard let cities = cities, cities.count >= indexPath.row else { return }

    do {
      let cityToDelete = cities[indexPath.row]
      try cityToDelete.delete()

    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) delete city")
    }
  }

  func select(at index: Int) {
    guard let selectedCity = cities?.filter("index = %@", index).first else { return }
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
  
  func relaodData(initialUpdate: @escaping () -> Void,
                  applyChanges: @escaping (_ deletions: [Int], _ insertions: [Int], _ updates: [Int]) -> Void) {
    cities = try! City.fetchAll().sorted(byKeyPath: CityProperty.index.key, ascending: true)
    citiesToken = cities?.observe { changes in
      switch changes {
      case .initial:
        initialUpdate()
        
      case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
        applyChanges(deletions, insertions, modifications)
        debugPrint("deletions: \(deletions)")
        debugPrint("insertions: \(insertions)")
        debugPrint("modifications: \(modifications)")
        
      case .error(let error):
        debugPrint(error)
      }
    }
  }
  
  func onViewWillDisappear() {
    citiesToken?.invalidate()
  }

}
