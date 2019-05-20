import XCTest

class CurrentForecastTests: XCTestCase {
  private var currentForecast: CurrentForecast!
  
  override func setUp() {
    super.setUp()
    currentForecast = ForecastGenerator.generateCurrentForecast()
  }
  
  override func tearDown() {
    currentForecast = nil
    super.tearDown()
  }
  
  func testForecastTimezone() {
    let timezone = ForecastGenerator.generateTimezone()
    XCTAssertEqual(timezone, "America/Chicago", "Forecast invalid timezone.")
  }
  
  func testExample() {

  }
  
}
