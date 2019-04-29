import XCTest

class SwiftyDailyForecastTests: BaseSwiftyForecastTests {
  var dailyForecast: DailyForecast!
  
  override func setUp() {
    super.setUp()
    
    dailyForecast = ForecastGenerator.generateDailyForecast()
  }
  
  override func tearDown() {
    super.tearDown()
    
    dailyForecast = nil
  }
  
  // TODO: Implement Unit testing

}
