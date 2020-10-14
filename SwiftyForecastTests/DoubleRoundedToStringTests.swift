import XCTest
@testable import SwiftyForecast

class DoubleRoundedToStringTests: XCTestCase {
  func testRoundAwayFromZero() {
    XCTAssertEqual(123.00.roundedToString, "123")
    XCTAssertEqual(123.456.roundedToString, "124")
    XCTAssertEqual(123.400.roundedToString, "124")
    XCTAssertEqual(12345.6.roundedToString, "12346")
    XCTAssertEqual(12345.67.roundedToString, "12346")
  }
}
