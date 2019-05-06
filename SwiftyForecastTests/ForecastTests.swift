import XCTest

class ForecastTests: BaseSwiftyForecastTests {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testForecastTimezone() {
    let expectedValue = "America/Chicago"
    
    XCTAssertEqual(timezone, expectedValue, "Forecast invalid timezone.")
  }
  
}
