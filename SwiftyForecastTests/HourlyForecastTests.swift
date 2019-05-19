import XCTest

class HourlyForecastTests: BaseSwiftyForecastTests {
  var hourlyForecast: HourlyForecast!
  
  override func setUp() {
    super.setUp()
    
    hourlyForecast = ForecastGenerator.generateHourlyForecast()
  }
  
  override func tearDown() {
    super.tearDown()
    
    MeasuringSystem.selected = .imperial
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
  
  func testHourlyForecastCellTimeAndConditionIcon() {
    let data = hourlyForecast.data.first!
    let hourlyDataViewModel = DefaultHourlyForecastCellViewModel(hourlyData: data)
    
    XCTAssertEqual(hourlyDataViewModel.time, "3:00 PM")
    XCTAssertEqual(hourlyDataViewModel.conditionIcon!, ConditionFontIcon.make(icon: "sleet", font: 25)!.attributedIcon)
    
  }
  
  func testHourlyCellTemperatureInCelsius() {
    let data = hourlyForecast.data.first!
    let hourlyDataViewModel = DefaultHourlyForecastCellViewModel(hourlyData: data)
    
    MeasuringSystem.selected = .metric
    XCTAssertEqual(hourlyDataViewModel.temperature, "1°")
  }
  
  func testHourlyCellTemperatureInFahrenheit() {
    let data = hourlyForecast.data.first!
    let hourlyDataViewModel = DefaultHourlyForecastCellViewModel(hourlyData: data)
    
    MeasuringSystem.selected = .imperial
    XCTAssertEqual(hourlyDataViewModel.temperature, "34°")
  }
  
  func testTemperatureRoundedToString() {
    let belowZero = -0.4
    XCTAssertEqual(belowZero.roundedToString, "-1")
  }
  
  // TODO: Implement Unit Testing
  
}
