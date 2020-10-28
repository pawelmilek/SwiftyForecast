import XCTest
@testable import SwiftyForecast

class NotationControllerTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var sut: NotationController!
  private var viewModelDaily: DailyCellViewModel!
  
  override func setUp() {
    super.setUp()
    
    let defaultsName = "NotationControllerTests"
    userDefaults = UserDefaults(suiteName: defaultsName)
    userDefaults.removePersistentDomain(forName: defaultsName)
    sut = NotationController(storage: userDefaults)

    let currentDayData = MockGenerator.generateDailyForecast().currentDayData
    viewModelDaily = DefaultDailyCellViewModel(dailyData: currentDayData, notationController: sut)
  }
  
  override func tearDown() {
    userDefaults = nil
    sut = nil
    super.tearDown()
  }
  
  func testSettingImperialUnitNotation() {
    sut.unitNotation = .imperial
    XCTAssertEqual(sut.unitNotation, UnitNotation.imperial)
  }
  
  func testSettingMetricUnitNotation() {
    sut.unitNotation = .metric
    XCTAssertEqual(sut.unitNotation, UnitNotation.metric)
  }
  
  func testSettingFahrenheitTemperatureNotation() {
    sut.temperatureNotation = .fahrenheit
    XCTAssertEqual(sut.temperatureNotation, .fahrenheit)
  }
  
  func testSettingCelsiusTemperatureNotation() {
    sut.temperatureNotation = .celsius
    XCTAssertEqual(sut.temperatureNotation, .celsius)
  }
  
  func testDailyMaxTemperature9Celsius() {
    sut.temperatureNotation = .celsius
    XCTAssertEqual(viewModelDaily.temperatureMax, "11°")
  }
  
  func testDailyMaxTemperature48Fahrenheit() {
    sut.temperatureNotation = .fahrenheit
    XCTAssertEqual(viewModelDaily.temperatureMax, "52°")
  }
  
}
