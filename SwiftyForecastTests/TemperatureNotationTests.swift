import XCTest

class TemperatureNotationTests: XCTestCase {
  private var dailyForecast: DailyForecast!
  private var hourlyForecast: HourlyForecast!
  private var viewModelDaily: DailyForecastCellViewModel!
  private var viewModelHourly: HourlyForecastCellViewModel!
  
  override func setUp() {
    super.setUp()
    
    dailyForecast = ForecastGenerator.generateDailyForecast()
    viewModelDaily = DefaultDailyForecastCellViewModel(dailyData: dailyForecast.sevenDaysData.first!)
    
    hourlyForecast = ForecastGenerator.generateHourlyForecast()
    viewModelHourly = DefaultHourlyForecastCellViewModel(hourlyData: hourlyForecast.data.first!)
  }
  
  override func tearDown() {
    super.tearDown()
    
    dailyForecast = nil
    viewModelDaily = nil
    hourlyForecast = nil
    viewModelHourly = nil
    UserDefaultsAdapter.resetNotation()
  }
  
  func testHourlyCellTemperatureInCelsius() {
    NotationSystem.selectedUnitNotation = .metric
    XCTAssertEqual(viewModelHourly.temperature, "1°")
  }
  
  func testHourlyCellTemperatureInFahrenheit() {
    NotationSystem.selectedUnitNotation = .imperial
    XCTAssertEqual(viewModelHourly.temperature, "34°")
  }
  
  func testTemperatureRoundedToString() {
    let belowZero = -0.4
    XCTAssertEqual(belowZero.roundedToString, "-1")
  }

  func testDailyTemperatureMaxInCelsius() {
    NotationSystem.selectedUnitNotation = .metric
    XCTAssertEqual(viewModelDaily.temperatureMax, "9°")
  }
  
  func testDailyTemperatureMaxInFahrenheit() {
    NotationSystem.selectedUnitNotation = .imperial
    XCTAssertEqual(viewModelDaily.temperatureMax, "48°")
  }
  
}
