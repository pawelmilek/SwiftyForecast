import RealmSwift

protocol CitySelectionViewModelDelegate: class {
  func didSelect(_ viewModel: CitySelectionViewModel, city: City)
}

final class DefaultCitySelectionViewModel: CitySelectionViewModel {
  var numberOfCities: Int {
    return cityViewModels.count
  }
  
  var onSuccess: (() -> Void)?
  var onFailure: ((Error) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  
  private var cities: Results<City> {
    let allCities = try! City.fetchAll()
    return allCities.sorted(byKeyPath: "index", ascending: true)
  }
  
  private lazy var cityViewModels: [CityViewModel] = {
    return cities.map { DefaultCityViewModel(city: $0) }
  }()

  weak var delegate: CitySelectionViewModelDelegate?
  
  init(delegate: CitySelectionViewModelDelegate) {
    self.delegate = delegate
  }
  
  func name(at index: Int) -> String {
    return cityViewModels[safe: index]?.name ?? InvalidReference.notApplicable
  }
  
  func localTime(at index: Int) -> String {
    return cityViewModels[safe: index]?.localTime ?? InvalidReference.notApplicable
  }
  
  func select(at index: Int) {
    guard let selectedCity = cities.filter("index = %@", index).first else { return }
    delegate?.didSelect(self, city: selectedCity)
  }
}

// MARK: - Private -
private extension DefaultCitySelectionViewModel {

}
