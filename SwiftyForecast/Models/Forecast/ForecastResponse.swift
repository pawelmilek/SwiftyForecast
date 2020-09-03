import RealmSwift
import CoreLocation

@objcMembers final class ForecastResponse: Object, Decodable {
  dynamic var compoundKey = "0|0"
  dynamic var timezone = ""
  dynamic var longitude = 0.0
  dynamic var latitude = 0.0
  dynamic var currently: CurrentForecast?
  dynamic var hourly: HourlyForecast?
  dynamic var daily: DailyForecast?
  dynamic var lastUpdate = Date()
  
  private enum CodingKeys: String, CodingKey {
    case timezone
    case longitude
    case latitude
    case currently
    case hourly
    case daily
  }
  
  private var compoundKeyValue: String {
    "\(self.latitude)|\(self.longitude)"
  }
  
  var location: CLLocation? {
    get {
      return CLLocation(latitude: latitude, longitude: longitude)
    }
    set {
      guard let newLocation = newValue?.coordinate else { return }
      latitude = newLocation.latitude
      longitude = newLocation.longitude
    }
  }
  
  convenience init(timezone: String,
                   longitude: Double,
                   latitude: Double,
                   currently: CurrentForecast,
                   hourly: HourlyForecast,
                   daily: DailyForecast) {
    self.init()
    self.timezone = timezone
    self.longitude = longitude
    self.latitude = latitude
    self.currently = currently
    self.hourly = hourly
    self.daily = daily
    self.compoundKey = compoundKeyValue
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timezone = try container.decode(String.self, forKey: .timezone)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let currently = try container.decode(CurrentForecast.self, forKey: .currently)
    let hourly = try container.decode(HourlyForecast.self, forKey: .hourly)
    let daily = try container.decode(DailyForecast.self, forKey: .daily)
    
    self.init(timezone: timezone,
              longitude: longitude,
              latitude: latitude,
              currently: currently,
              hourly: hourly,
              daily: daily)
  }
  
  required init() {
    super.init()
  }
  
  override static func primaryKey() -> String? {
    "compoundKey"
  }
}

// MARK: - CRUD methods
extension ForecastResponse {
  
  static func fetchAll(in realm: Realm? = RealmProvider.core.realm) throws -> Results<ForecastResponse> {
    guard let realm = realm else { throw RealmError.initializationFailed }
    return realm.objects(ForecastResponse.self)
  }
  
  static func add(_ response: ForecastResponse, in realm: Realm? = RealmProvider.core.realm) throws {
    guard let realm = realm else { throw RealmError.initializationFailed }

    do {
      try realm.write {
        realm.add(response, update: .all)
      }
    } catch {
      throw RealmError.transactionFailed(description: "Adding new forecast response")
    }
  }
  
}
