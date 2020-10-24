import Foundation
import CoreLocation
import RealmSwift
import MapKit
import Intents
import Contacts

@objcMembers final class City: Object, Codable {
  dynamic var orderIndex = 0
  dynamic var compoundKey = "\(InvalidReference.undefined)|\(InvalidReference.undefined)|\(InvalidReference.undefined)"
  dynamic var name = ""
  dynamic var country = ""
  dynamic var state = ""
  dynamic var postalCode = ""
  dynamic var timeZoneIdentifier = ""
  dynamic var lastUpdate = Date()
  dynamic var isUserLocation = false
  dynamic var latitude = 0.0
  dynamic var longitude = 0.0
  
  private var compoundKeyValue: String {
    "\(self.name)|\(self.country)|\(self.state)"
  }
  
  var placemark: CLPlacemark? {
    let placemark = CLPlacemark(location: location, name: name, postalAddress: nil)
    return placemark
  }
  
  var localTime: String {
    DateFormatter.shortLocalTime(from: timeZoneIdentifier)
  }

  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  private enum CityCodingKeys: String, CodingKey {
    case name
    case country
    case state
    case postalCode
    case timeZoneName
    case isUserLocation
    case latitude
    case longitude
  }
  
  
  override static func primaryKey() -> String? {
    CityProperty.orderIndex.key
  }
  
  convenience init(name: String,
                   country: String,
                   state: String,
                   postalCode: String,
                   timeZoneIdentifier: String,
                   latitude: Double,
                   longitude: Double,
                   isUserLocation: Bool = false) {
    self.init()
    self.name = name
    self.country = country
    self.state = state
    self.postalCode = postalCode
    self.timeZoneIdentifier = timeZoneIdentifier
    self.isUserLocation = isUserLocation
    self.latitude = latitude
    self.longitude = longitude
    self.compoundKey = compoundKeyValue
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityCodingKeys.self)
    
    let name = try container.decode(String.self, forKey: .name)
    let country = try container.decode(String.self, forKey: .country)
    let state = try container.decode(String.self, forKey: .state)
    let postal = try container.decode(String.self, forKey: .postalCode)
    let timeZoneName = try container.decode(String.self, forKey: .timeZoneName)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    
    self.init(name: name,
              country: country,
              state: state,
              postalCode: postal,
              timeZoneIdentifier: timeZoneName,
              latitude: latitude,
              longitude: longitude)
  }
  
  required init() {
    super.init()
  }
  
  convenience init(placemark: CLPlacemark, isUserLocation: Bool) {
    self.init()

    name = placemark.locality ?? InvalidReference.notApplicable
    country = placemark.country ?? InvalidReference.notApplicable
    state = placemark.administrativeArea ?? InvalidReference.notApplicable
    postalCode = placemark.postalCode ?? InvalidReference.notApplicable
    timeZoneIdentifier = placemark.timeZone?.identifier ?? InvalidReference.notApplicable
    self.isUserLocation = isUserLocation
    latitude = placemark.location?.coordinate.latitude ?? 0.0
    longitude = placemark.location?.coordinate.longitude ?? 0.0
    self.compoundKey = compoundKeyValue
  }
}

// MARK: - CRUD methods
extension City {
  
  static func fetchAll(in realm: Realm? = RealmProvider.core.realm) throws -> Results<City> {
    guard let realm = realm else { throw RealmError.initializationFailed }
    return realm.objects(City.self)
  }
  
  static func fetchAllOrderedByIndex(in realm: Realm? = RealmProvider.core.realm) throws -> Results<City> {
    guard let realm = realm else { throw RealmError.initializationFailed }
    
    let sortDescriptors = [SortDescriptor(keyPath: CityProperty.orderIndex.key, ascending: true),
                           SortDescriptor(keyPath: CityProperty.isUserLocation.key, ascending: false)]
    return realm.objects(City.self).sorted(by: sortDescriptors)
  }
  
  static func add(_ city: City, in realm: Realm? = RealmProvider.core.realm) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      city.orderIndex = nextSortIndex(in: realm)
      
      try realm.write {
        realm.add(city, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
  }
  
  static func add(from placemark: CLPlacemark, isUserLocation: Bool = true, in realm: Realm? = RealmProvider.core.realm) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      let newCity = City(placemark: placemark, isUserLocation: isUserLocation)
      newCity.orderIndex = nextSortIndex(in: realm)
      newCity.isUserLocation = isUserLocation
      
      try realm.write {
        realm.add(newCity, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
  }
  
  static func add(_ city: City, sortIndex: Int, in realm: Realm? = RealmProvider.core.realm) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      city.orderIndex = sortIndex
      
      try realm.write {
        realm.add(city, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new city")
    }
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
  
  private static func nextSortIndex(in realm: Realm? = RealmProvider.core.realm) -> Int {
    return (realm?.objects(City.self).map{ $0.orderIndex }.max() ?? 0) + 1
  }
  
}
