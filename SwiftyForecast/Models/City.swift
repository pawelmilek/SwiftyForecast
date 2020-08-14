import Foundation
import CoreLocation
import RealmSwift
import MapKit
import Intents
import Contacts

@objcMembers final class City: Object, Codable {
  dynamic var index = 0
  dynamic var name = ""
  dynamic var country = ""
  dynamic var state = ""
  dynamic var postalCode = ""
  dynamic var timeZoneName = ""
  dynamic var lastUpdate = Date()
  dynamic var isCurrentLocalization = false
  private var latitude = RealmOptional<Double>()
  private var longitude = RealmOptional<Double>()
  
  var placemark: CLPlacemark? {
    guard let location = location else { return nil }
    let placemark = CLPlacemark(location: location, name: name, postalAddress: nil)
    return placemark
  }
  
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
    let postal = try container.decode(String.self, forKey: .postalCode)
    let timeZone = try container.decode(String.self, forKey: .timeZoneName)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    self.init(name: name, country: country, state: state, postalCode: postal, timeZoneName: timeZone, location: location)
  }
  
  required init() {
    super.init()
  }
  
  override static func primaryKey() -> String? {
    return CityProperty.index.key
  }
  
  convenience init(placemark: CLPlacemark) {
    self.init()

    name = placemark.locality ?? InvalidReference.notApplicable
    country = placemark.country ?? InvalidReference.notApplicable
    state = placemark.administrativeArea ?? InvalidReference.notApplicable
    postalCode = placemark.postalCode ?? InvalidReference.notApplicable
    timeZoneName = placemark.timeZone?.identifier ?? InvalidReference.notApplicable
    isCurrentLocalization = true
    location = CLLocation(latitude: placemark.location?.coordinate.latitude ?? 0.0,
                          longitude: placemark.location?.coordinate.longitude ?? 0.0)
  }
}

// MARK: - Local time
extension City {
  
  var localTime: String {
    return DateFormatter.shortLocalTime(from: timeZoneName)
  }
  
}

// MARK: - CRUD methods
extension City {
  
  static func fetchAll(in realm: Realm? = RealmProvider.core.realm) throws -> Results<City> {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    return realm.objects(City.self).sorted(byKeyPath: CityProperty.isCurrentLocalization.key)
  }
  
  static func fetchCurrent(in realm: Realm? = RealmProvider.core.realm) throws -> City? {
    guard let realm = realm else {
      throw RealmError.initializationFailed
    }
    return realm.objects(City.self).sorted(byKeyPath: CityProperty.isCurrentLocalization.key).first
  }
  
  @discardableResult
  static func add(from placemark: CLPlacemark,
                  at index: Int? = nil,
                  in realm: Realm? = RealmProvider.core.realm) throws -> City {
    guard let realm = realm else { throw RealmError.initializationFailed }
    
    let newCity = City(placemark: placemark)
    if let index = index {
      newCity.index = index
    } else {
      newCity.index = nextId(in: realm)
    }
    
    do {
      try realm.write {
        realm.add(newCity, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
    
    return newCity
  }
  
  @discardableResult
  static func add(_ city: City,
                  at index: Int? = nil,
                  in realm: Realm? = RealmProvider.core.realm) throws -> City {
    guard let realm = realm else { throw RealmError.initializationFailed }
    
    if let index = index {
      city.index = index
    } else {
      city.index = nextId(in: realm)
    }
    
    do {
      try realm.write {
        realm.add(city, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
    
    return city
  }
  
  func delete() throws {
    guard let realm = realm else { throw RealmError.initializationFailed }
    
    do {
      try realm.write {
        realm.delete(self)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting city")
    }
  }
  
  static func deleteAll(in realm: Realm? = RealmProvider.core.realm) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }
    
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      throw RealmError.transactionFailed(description: "Deleting all cities")
    }
  }
  
}

// MARK: - ID interator
extension City {
  
  private static func nextId(in realm: Realm? = RealmProvider.core.realm) -> Int {
    return (realm?.objects(City.self).map{ $0.index }.max() ?? 0) + 1
  }
  
}
