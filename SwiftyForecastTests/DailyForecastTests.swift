import XCTest

class DailyForecastTests: XCTestCase {
  private var dailyForecast: DailyForecast!
  private var viewModel: DailyForecastCellViewModel!
  
  override func setUp() {
    super.setUp()
    
    dailyForecast = ForecastGenerator.generateDailyForecast()
    let data = dailyForecast.sevenDaysData.first!
    viewModel = DefaultDailyForecastCellViewModel(dailyData: data)
  }
  
  override func tearDown() {
    super.tearDown()
    
    dailyForecast = nil
    viewModel = nil
  }
  
  func testDailySummary() {
    XCTAssertEqual(dailyForecast.summary, "Rain today through Thursday, with high temperatures rising to 64°F on Thursday.")
  }
  
  func testDailyIcon() {
    XCTAssertEqual(dailyForecast.icon, "rain")
  }
  
  func testDailyAttributedDate() {
    let expectedValue = DailyDateRenderer.render(weekday: "SUNDAY", month: "APRIL 28")
    XCTAssertEqual(viewModel.attributedDate, expectedValue)
  }
  
  func testDailyConditionIcon() {
    let expectedValue = ConditionFontIcon.make(icon: "partly-cloudy-night", font: 22)!.attributedIcon
    XCTAssertEqual(viewModel.conditionIcon!, expectedValue)
  }
  
  func testDailySevenDaysForecast() {
    XCTAssertEqual(dailyForecast.sevenDaysData.count, 7)
  }
  
  func testDailyTemperatureMaxInCelsius() {
    MeasuringSystem.selected = .metric
    XCTAssertEqual(viewModel.temperatureMax, "48°")
  }
  
  func testDailyTemperatureMaxInFahrenheit() {
    MeasuringSystem.selected = .imperial
    XCTAssertEqual(viewModel.temperatureMax, "9°")
  }
}
