import XCTest

class UnitNotationTests: XCTestCase {
  private var viewModelDaily: DailyForecastCellViewModel!
  private var viewModelHourly: HourlyForecastCellViewModel!
  private var viewModelCurrent: CurrentForecastViewModel!
  
  override func setUp() {
    super.setUp()
    
    let dailyForecast = ForecastGenerator.generateDailyForecast()
    viewModelDaily = DefaultDailyForecastCellViewModel(dailyData: dailyForecast.sevenDaysData.first!)
    
    let hourlyForecast = ForecastGenerator.generateHourlyForecast()
    viewModelHourly = DefaultHourlyForecastCellViewModel(hourlyData: hourlyForecast.data.first!)
    
//    let currentForecast = ForecastGenerator.generateCurrentForecast()
    //    viewModel = DefaultCurrentForecastViewModel(currentForecast: CurrentForecast, currentDayDetails details: DailyData, city: City)
  }
  
  override func tearDown() {
    super.tearDown()
    
    viewModelDaily = nil
    viewModelHourly = nil
    viewModelCurrent = nil
    ForecastUserDefaults.resetNotation()
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
  
  func testDailyWindSpeedMPH() {
    NotationSystem.selectedUnitNotation = .imperial
//    XCTAssertEqual(viewModelCurrent.windSpeed, "5 MPH")
  }
  
  func testDailyWindSpeedKPH() {
    NotationSystem.selectedUnitNotation = .metric
//    XCTAssertEqual(viewModelCurrent.windSpeed, "8 KPH")
  }
}
