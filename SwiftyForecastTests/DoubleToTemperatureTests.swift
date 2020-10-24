import XCTest
@testable import SwiftyForecast

class DoubleToTemperatureTests: XCTestCase {
  
  func testTenFahrenheitToCelsius() {
    XCTAssertEqual(10.0.ToCelsius(), -12.222222222220125)
  }
  
  func testTwentyTwoAndHalfFahrenheitToCelsius() {
    XCTAssertEqual(22.5.ToCelsius(), -5.277777777775611)
  }
  
  func testEightyEightFahrenheitToCelsius() {
    XCTAssertEqual(88.0.ToCelsius(), 31.111111111113587)
  }
  
  func testTenCelsiusToFahrenheit() {
    XCTAssertEqual(10.0.ToFahrenheit(), 49.99999999999585)
  }
  
  func testTwentyTwoAndHalfCelsiusToFahrenheit() {
    XCTAssertEqual(22.5.ToFahrenheit(), 72.49999999999567)
  }
  
  func testEightyEightCelsiusToFahrenheit() {
    XCTAssertEqual(88.0.ToFahrenheit(), 190.39999999999472)
  }
}
