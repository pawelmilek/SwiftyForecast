import Foundation
import CoreLocation
import RealmSwift

@objcMembers final class CityRealm: Object, Codable {
  dynamic var cityId = NSUUID().uuidString
  dynamic var name = ""
  dynamic var country = ""
  dynamic var state = ""
  dynamic var postalCode = ""
  dynamic var timeZoneName = ""
  dynamic var lastUpdate = Date()
  dynamic var isCurrentLocalization = false
  private var latitude = RealmOptional<Double>()
  private var longitude = RealmOptional<Double>()
  
  var location: CLLocation? {
    get {
      guard let latitude = latitude.value, let longitude = longitude.value else { return nil }
      return CLLocation(latitude: latitude, longitude: longitude)
    }
    set {
      guard let newLocation = newValue?.coordinate else {
        longitude.value = nil
        latitude.value = nil
        return
      }
      latitude.value = newLocation.latitude
      longitude.value = newLocation.longitude
    }
  }
  
  private enum CityCodingKeys: String, CodingKey {
    case name
    case country
    case state
    case postalCode
    case timeZoneName
    case isCurrentLocalization
    case latitude
    case longitude
  }
  
  convenience init(name: String,
                   country: String,
                   state: String,
                   postalCode: String,
                   timeZoneName: String,
                   location: CLLocation?,
                   isCurrentLocalization: Bool = false) {
    self.init()
    self.name = name
    self.country = country
    self.state = state
    self.postalCode = postalCode
    self.timeZoneName = timeZoneName
    self.location = location
    self.isCurrentLocalization = isCurrentLocalization
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityCodingKeys.self)

    let name = try container.decode(String.self, forKey: .name)
    let country = try container.decode(String.self, forKey: .country)
    let state = try container.decode(String.self, forKey: .state)
    let postalCode = try container.decode(String.self, forKey: .postalCode)
    let timeZoneName = try container.decode(String.self, forKey: .timeZoneName)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    self.init(name: name,
              country: country,
              state: state,
              postalCode: postalCode,
              timeZoneName: timeZoneName,
              location: location)
  }
  
  required init() {
      super.init()
  }

  override static func primaryKey() -> String? {
    return CityRealmProperty.cityId.rawValue
  }
  
  convenience init(placemark: CLPlacemark) {
    self.init()

    name = placemark.locality ?? "N/A"
    country = placemark.country ?? "N/A"
    state = placemark.administrativeArea ?? "N/A"
    postalCode = placemark.postalCode ?? "N/A"
    timeZoneName = placemark.timeZone?.identifier ?? "N/A"
    isCurrentLocalization = true
    location = CLLocation(latitude: placemark.location?.coordinate.latitude ?? 0.0,
                          longitude: placemark.location?.coordinate.longitude ?? 0.0)
  }
}

// MARK: - Local time
extension CityRealm {
  
  var localTime: String {
    return DateFormatter.shortLocalTime(from: timeZoneName)
  }
  
}

// MARK: - CRUD methods
extension CityRealm {
  
  static func fetchAll(in realm: Realm? = RealmProvider.cities.realm) throws -> Results<CityRealm> {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    return realm.objects(CityRealm.self).sorted(byKeyPath: CityRealmProperty.isCurrentLocalization.rawValue)
  }
  
  static func fetchCurrent(in realm: Realm? = RealmProvider.cities.realm) throws -> CityRealm? {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    return realm.objects(CityRealm.self).sorted(byKeyPath: CityRealmProperty.isCurrentLocalization.rawValue).first
  }
  
  @discardableResult
  static func add(from placemark: CLPlacemark, in realm: Realm? = RealmProvider.cities.realm) throws -> CityRealm {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    
    let newCity = CityRealm(placemark: placemark)
    do {
      try realm.write {
        realm.add(newCity)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
    
    return newCity
  }
  
  func delete() throws {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    
    do {
      try realm.write {
        realm.delete(self)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting city")
    }
  }
  
  static func deleteAll(in realm: Realm? = RealmProvider.cities.realm) throws {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting all cities")
    }
  }

}

// MARK: - Is city exists in Core Data
extension CityRealm {
  
  func isExists() -> Bool {
    guard let cities = try? CityRealm.fetchAll() else { return false }
    
    let predicate = NSPredicate(format: "name == %@ && country == %@", name, country)
    let searchResults = cities.filter(predicate)
    
    return searchResults.count > 0 ? true : false
  }
  
}