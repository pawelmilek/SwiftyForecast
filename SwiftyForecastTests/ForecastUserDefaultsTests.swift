import XCTest
@testable import SwiftyForecast

class ForecastUserDefaultsTests: XCTestCase {
  override func setUp() {
    super.setUp()
    ForecastUserDefaults.resetNotation()
  }
  
  override func tearDown() {
    super.tearDown()
    ForecastUserDefaults.resetNotation()
  }
  
  func testSettingImperialUnitNotation() {
    ForecastUserDefaults.set(notation: .imperial)
    let expected = UnitNotation.imperial
    XCTAssertEqual(ForecastUserDefaults.unitNotation, expected)
  }
  
  func testSettingMetricUnitNotation() {
    ForecastUserDefaults.set(notation: .metric)
    let expected = UnitNotation.metric
    XCTAssertEqual(ForecastUserDefaults.unitNotation, expected)
  }
  
  func testResettingSetupUnitNotation() {
    ForecastUserDefaults.set(notation: .metric)
    ForecastUserDefaults.resetNotation()

    let expected = UnitNotation.imperial
    XCTAssertEqual(ForecastUserDefaults.unitNotation, expected)
  }
  
  func testSettingFahrenheitTemperatureNotation() {
    ForecastUserDefaults.set(notation: .imperial)
    let expected = TemperatureNotation.fahrenheit
    XCTAssertEqual(ForecastUserDefaults.temperatureNotation, expected)
  }
  
  func testSettingCelsiusTemperatureNotation() {
    ForecastUserDefaults.set(notation: .metric)
    let expected = TemperatureNotation.celsius
    XCTAssertEqual(ForecastUserDefaults.temperatureNotation, expected)
  }
  
}
