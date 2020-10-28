import Foundation
import MapKit
import Intents
import Contacts
import CoreLocation
@testable import SwiftyForecast

struct MockGenerator {
  private static var forecastDTO: ForecastDTO = {
    return ModelTranslator().translate(forecast: MockGenerator.generateForecast()!)!
  }()

  static func generateTimezone() -> String {
    return forecastDTO.timezone
  }
  
  static func generateCurrentForecast() -> CurrentForecastDTO {
    return forecastDTO.currently
  }
  
  static func generateHourlyForecast() -> HourlyForecastDTO {
    return forecastDTO.hourly
  }
  
  static func generateDailyForecast() -> DailyForecastDTO {
    return forecastDTO.daily
  }
  
  static func generateForecast() -> ForecastResponse? {
    do {
      let data = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
      let result = NetworkResponseParser<ForecastResponse>.parseJSON(data)
      
      switch result {
      case .success(let data):
        return data
        
      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error.localizedDescription)")
      }
      
    } catch {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error.localizedDescription)")
    }
    
    return nil
  }
}

// MARK: - Data Transfer Objects
extension MockGenerator {
  
  static func generateCityDTO() -> CityDTO {
    let latitude = 37.33233141
    let longitude = -122.0312186
    let name = "Cupertino"
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let placemark = CLPlacemark(location: location, name: name, postalAddress: nil)
    let cityDTO = CityDTO(compoundKey: "Cupertino|United States|CA",
                          name: "Cupertino",
                          country: "United States",
                          state: "CA",
                          postalCode: "95014",
                          timeZoneIdentifier: "America/Los_Angeles",
                          lastUpdate: Date(), //"2020-10-18T18:56:04.793Z",
                          isUserLocation: true,
                          latitude: latitude,
                          longitude: longitude,
                          placemark: placemark,
                          localTime: "10:00AM")
    
    return cityDTO
  }
}
