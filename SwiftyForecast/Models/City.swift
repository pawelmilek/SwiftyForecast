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
    self.name = try container.decode(String.self, forKey: .name)
    self.country = try container.decode(String.self, forKey: .country)
    self.state = try container.decodeIfPresent(String.self, forKey: .state)
    self.postalCode = try container.decode(String.self, forKey: .postalCode)
    self.isCurrentLocalization = try container.decode(Bool.self, forKey: .isCurrentLocalization)
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.timeZone = try container.decodeIfPresent(TimeZone.self, forKey: .timeZone)
    self.lastUpdate = try container.decodeIfPresent(Date.self, forKey: .lastUpdate)
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
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name ?? "N/A"
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.isCurrentLocalization = isCurrentLocalization
    self.latitude = place.coordinate.latitude
    self.longitude = place.coordinate.longitude
  }
  
  convenience init(unassociatedObject: City, isCurrentLocalization: Bool, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    self.name = unassociatedObject.name
    self.country = unassociatedObject.country
    self.state = unassociatedObject.state
    self.postalCode = unassociatedObject.postalCode
    self.isCurrentLocalization = isCurrentLocalization
    self.latitude = unassociatedObject.latitude
    self.longitude = unassociatedObject.longitude
  }
  
  convenience init(place: GMSPlace) {
    let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: CoreDataStackHelper.shared.managedContext)!
    self.init(entity: entity, insertInto: nil)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.isCurrentLocalization = false
    self.latitude = place.coordinate.latitude
    self.longitude = place.coordinate.longitude
  }
}

// MARK: - Local time
extension City {
  
  var localTime: String {
    guard let timezone = self.timeZone else { return "N/A" }
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
    let predicate = NSPredicate(format: "name == %@ && country == %@", self.name, self.country)
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
