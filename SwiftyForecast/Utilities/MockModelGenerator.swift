import Foundation
import CoreLocation
import RealmSwift

struct MockModelGenerator {

    static func generateWeatherModel() -> WeatherModel {
        do {
            let currentWeatherData = try JSONFileLoader.loadFile(with: "current_weather_response")
            let fiveDaysForecastWeatherData = try JSONFileLoader.loadFile(with: "five_days_forecast_weather_response")

            let currentResponse = JSONParser<CurrentWeatherResponse>.parse(currentWeatherData)
            let forecastResponse = JSONParser<ForecastWeatherResponse>.parse(fiveDaysForecastWeatherData)

            let model = ResponseParser.parse((currentResponse, forecastResponse))
            return model

        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func generateLocationModel() -> LocationModel {
        do {
            let currentWeatherData = try JSONFileLoader.loadFile(with: "current_weather_response")
            let currentResponse = JSONParser<CurrentWeatherResponse>.parse(currentWeatherData)
            let locationModel = LocationModel()
            locationModel._id = ObjectId.generate()
            locationModel.compoundKey = "name||state||country||postalCode"
            locationModel.name = currentResponse.name
            locationModel.country = "Poland"
            locationModel.state = ""
            locationModel.postalCode = ""
            locationModel.secondsFromGMT = currentResponse.timezone
            locationModel.latitude = currentResponse.coordinate.latitude
            locationModel.longitude = currentResponse.coordinate.longitude
            locationModel.lastUpdate = Date()
            locationModel.isUserLocation = false
            return locationModel

        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

//// MARK: - Data Transfer Objects
//extension MockModelGenerator {
//
//  static func generateCityDTO() -> LocationModel {
//    let latitude = 37.33233141
//    let longitude = -122.0312186
//    let name = "Cupertino"
//    let location = CLLocation(latitude: latitude, longitude: longitude)
//    let placemark = CLPlacemark(location: location, name: name, postalAddress: nil)
//    let cityDTO = LocationModel(compoundKey: "Cupertino|United States|CA",
//                          name: "Cupertino",
//                          country: "United States",
//                          state: "CA",
//                          postalCode: "95014",
//                          timeZoneIdentifier: "America/Los_Angeles",
//                          lastUpdate: Date(), // "2020-10-18T18:56:04.793Z",
//                          isUserLocation: true,
//                          latitude: latitude,
//                          longitude: longitude,
//                          placemark: placemark,
//                          localTime: "10:00AM")
//
//    return cityDTO
//  }
//}
