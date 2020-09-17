import XCTest
@testable import SwiftyForecast

class CurrentForecastTests: XCTestCase {
  private var currentForecast: CurrentForecastDTO!
//  private var viewModel: CurrentForecastViewModel!
  
  override func setUp() {
    super.setUp()
    currentForecast = ForecastGenerator.generateCurrentForecast()
//    viewModel = DefaultCurrentForecastViewModel(currentForecast: CurrentForecast, currentDayDetails details: DailyData, city: City)
  }
  
  override func tearDown() {
    currentForecast = nil
//    viewModel = nil
    super.tearDown()
  }
  
  func testForecastTimezone() {
    let timezone = ForecastGenerator.generateTimezone()
    XCTAssertEqual(timezone, "America/Chicago", "Forecast invalid timezone.")
  }
}
