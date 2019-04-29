import XCTest

class SwiftyHourlyForecastTests: BaseSwiftyForecastTests {
  var hourlyForecast: HourlyForecast!
  
  override func setUp() {
    super.setUp()
    
    hourlyForecast = ForecastGenerator.generateHourlyForecast()
  }
  
  override func tearDown() {
    super.tearDown()
    
    hourlyForecast = nil
  }
  
  func testHourlyForecastIcon() {
    let newIcon = hourlyForecast.icon
    let expectedValue = "sleet"
    XCTAssertEqual(newIcon, expectedValue, "Hourly forecast icon is incorrect.")
  }
  
  func testHourlyForecastSummary() {
    let summary = hourlyForecast.summary
    let expectedValue = "Mixed precipitation throughout the day."
    XCTAssertEqual(summary, expectedValue, "Hourly forecast summary is incorrect.")
  }
  
  func testHourlyForecastNumberOfHours() {
    let hours = hourlyForecast.data.count
    let expectedValue = 24
    XCTAssertEqual(hours, expectedValue, "Forecast's number of hourly is incorrect.")
  }
  
  func testHourlyForecast() {
    let data = hourlyForecast.data.first!
    let hourlyDataViewModel = DefaultHourlyDataViewModel(hourlyData: data)
  }
  
  func testTemperatureRoundedToString() {
    let belowZero = -0.4
    let newValue = belowZero.roundedToString
    let expectedValue = "-1"
    XCTAssertEqual(newValue, expectedValue, "String temperature should be \(expectedValue)")
  }
  
  // TODO: Implement Unit Testing
  
}
