import XCTest

class HourlyForecastTests: BaseSwiftyForecastTests {
  private var hourlyForecast: HourlyForecast!
  private var viewModel: HourlyForecastCellViewModel!
  
  override func setUp() {
    super.setUp()
    hourlyForecast = ForecastGenerator.generateHourlyForecast()
    let data = hourlyForecast.data.first!
    viewModel = DefaultHourlyForecastCellViewModel(hourlyData: data)
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
  
  func testHourlyCellTemperatureInCelsius() {
    MeasuringSystem.selected = .metric
    XCTAssertEqual(viewModel.temperature, "1°")
  }
  
  func testHourlyCellTemperatureInFahrenheit() {
    MeasuringSystem.selected = .imperial
    XCTAssertEqual(viewModel.temperature, "34°")
  }
  
  func testTemperatureRoundedToString() {
    let belowZero = -0.4
    XCTAssertEqual(belowZero.roundedToString, "-1")
  }
}
