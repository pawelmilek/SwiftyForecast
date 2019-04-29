import XCTest

class BaseSwiftyForecastTests: XCTestCase {
//  var weatherForecast: WeatherForecast!
  var timezone: String!
  
  override func setUp() {
    super.setUp()
    
//    weatherForecast = ForecastGenerator.generateWeatherForecast()
    timezone = ForecastGenerator.generateTimezone()
  }
  
  override func tearDown() {
    super.tearDown()
    
//    weatherForecast = nil
    timezone = nil
  }
  
  // TODO: Implement Unit Testing
}
