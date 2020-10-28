import XCTest
@testable import SwiftyForecast

class HourlyForecastTests: XCTestCase {
  private var hourlyForecast: HourlyForecastDTO!
  private var viewModel: HourlyCellViewModel!
  
  override func setUp() {
    super.setUp()
    hourlyForecast = MockGenerator.generateHourlyForecast()
    let data = hourlyForecast.data.first!
    viewModel = DefaultHourlyCellViewModel(hourlyData: data)
  }
  
  override func tearDown() {
    super.tearDown()
    hourlyForecast = nil
    viewModel = nil
  }
  
  func testHourlyForecastIcon() {
    let newIcon = hourlyForecast.icon
    XCTAssertEqual(newIcon, "sleet", "Hourly forecast icon is incorrect.")
  }
  
  func testHourlyForecastSummary() {
    let summary = hourlyForecast.summary
    XCTAssertEqual(summary, "Mixed precipitation throughout the day.", "Hourly forecast summary is incorrect.")
  }
  
  func testHourlyForecastNumberOfHours() {
    let hours = hourlyForecast.data.count
    let expectedValue = 24
    XCTAssertEqual(hours, expectedValue, "Forecast's number of hourly is incorrect.")
  }
  
  func testHourlyForecastCellTimeAndConditionIcon() {
    let expectedValue = ConditionFontIcon.make(icon: "sleet", font: 25)!.attributedIcon
    XCTAssertEqual(viewModel.time, "3:00 PM")
    XCTAssertEqual(viewModel.conditionIcon!, expectedValue)
    
  }
}
