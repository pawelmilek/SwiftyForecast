import Foundation
import GooglePlaces
import CoreData

final class City: NSManagedObject, Codable {
  @NSManaged var name: String
  @NSManaged var country: String
  @NSManaged var state: String?
  @NSManaged var postalCode: String
  @NSManaged var isCurrentLocalization: Bool
  @NSManaged var latitude: Double
  @NSManaged var longitude: Double
  @NSManaged var timeZone: TimeZone?
  @NSManaged var lastUpdate: Date?
  @NSManaged var coordinate: Coordinate?
  
  private enum CodingKeys: String, CodingKey {
    case name
    case country
    case state
    case postalCode
    case isCurrentLocalization
    case latitude
    case longitude
    case timeZone
    case lastUpdate
  }
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    lastUpdate = Date()
  }
  
  required convenience init(from decoder: Decoder) throws {
    var entityDescription: NSEntityDescription?
        
    if let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: managedObjectContext) {
      entityDescription = entity
    } else {
      entityDescription = NSEntityDescription.entity(forEntityName: City.entityName, in: CoreDataStackHelper.shared.managedContext)
    }
    
    self.init(entity: entityDescription!, insertInto: nil)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    country = try container.decode(String.self, forKey: .country)
    state = try container.decodeIfPresent(String.self, forKey: .state)
    postalCode = try container.decode(String.self, forKey: .postalCode)
    isCurrentLocalization = try container.decode(Bool.self, forKey: .isCurrentLocalization)
    latitude = try container.decode(Double.self, forKey: .latitude)
    longitude = try container.decode(Double.self, forKey: .longitude)
    timeZone = try container.decodeIfPresent(TimeZone.self, forKey: .timeZone)
    lastUpdate = try container.decodeIfPresent(Date.self, forKey: .lastUpdate)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(country, forKey: .country)
    try container.encode(state, forKey: .state)
    try container.encode(postalCode, forKey: .postalCode)
    try container.encode(isCurrentLocalization, forKey: .isCurrentLocalization)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
    try container.encodeIfPresent(timeZone, forKey: .timeZone)
    try container.encodeIfPresent(lastUpdate, forKey: .lastUpdate)
  }

  convenience init(place: GMSPlace, isCurrentLocalization: Bool, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    let addressComponents = place.addressComponents
    
    name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name ?? "N/A"
    postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.isCurrentLocalization = isCurrentLocalization
    latitude = place.coordinate.latitude
    longitude = place.coordinate.longitude
  }
  
  convenience init(unassociatedObject: City, isCurrentLocalization: Bool, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    name = unassociatedObject.name
    country = unassociatedObject.country
    state = unassociatedObject.state
    postalCode = unassociatedObject.postalCode
    self.isCurrentLocalization = isCurrentLocalization
    latitude = unassociatedObject.latitude
    longitude = unassociatedObject.longitude
  }
  
  convenience init(place: GMSPlace) {
    let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: CoreDataStackHelper.shared.managedContext)!
    self.init(entity: entity, insertInto: nil)
    
    let addressComponents = place.addressComponents
    
    name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    isCurrentLocalization = false
    latitude = place.coordinate.latitude
    longitude = place.coordinate.longitude
  }
  
  convenience init(place: CLPlacemark) {
    let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: CoreDataStackHelper.shared.managedContext)!
    self.init(entity: entity, insertInto: nil)

    name = place.locality ?? "N/A"
    country = place.country ?? "N/A"
    state = place.administrativeArea ?? "N/A"
    postalCode = place.postalCode ?? "N/A"
    latitude = place.location?.coordinate.latitude ?? 0.0
    longitude = place.location?.coordinate.longitude ?? 0.0
    
    isCurrentLocalization = false
  }
}

// MARK: - Local time
extension City {
  
  var localTime: String {
    guard let timezone = timeZone else { return "N/A" }
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    formatter.timeZone = timezone
    
    let localTime = formatter.string(from: Date())
    return localTime
  }
  
}

// MARK: - Create fetch request
extension City {
  
  class func createFetchRequest() -> NSFetchRequest<City> {
    return NSFetchRequest<City>(entityName: City.entityName)
  }
  
}

// MARK: - Is city exists in Core Data
extension City {
  
  func isExists() -> Bool {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@", name, country)
    request.predicate = predicate
    
    do {
      let result = try CoreDataStackHelper.shared.managedContext.fetch(request)
      if result.count > 0 {
        return true
      } else {
        return false
      }
    } catch {
      CoreDataError.couldNotFetch.handler()
      return false
    }
  }
  
}
