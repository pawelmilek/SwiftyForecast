import XCTest
@testable import SwiftyForecast

class DateFormatterShortLocalTimeTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testAmericaChicagoShortLocalTime() {
    let timezone = "America/Chicago"
    let result = DateFormatter.shortLocalTime(from: timezone)
    XCTAssertNotEqual(result, InvalidReference.notApplicable)
  }
  
  func testNotApplicableShortLocalTime() {
    let timezone = "Invalid"
    let result = DateFormatter.shortLocalTime(from: timezone)
    XCTAssertEqual(result, InvalidReference.notApplicable)
  }
}
