import XCTest
@testable import SwiftyForecast

class DoubleToKPHTests: XCTestCase {

    func testOneMileDistance() {
      XCTAssertEqual(1.0.toKPH(), 1.609344)
    }

  func testTwoMilesDistance() {
    XCTAssertEqual(2.0.toKPH(), 3.218688)
  }
  
  func testTenMilesDistance() {
    XCTAssertEqual(10.0.toKPH(), 16.09344)
  }

}
