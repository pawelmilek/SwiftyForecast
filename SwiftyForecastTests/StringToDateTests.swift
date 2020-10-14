import XCTest
@testable import SwiftyForecast

class StringToDateTests: XCTestCase {
  
  func testYYYYMMDDFormat() {
    let stringDate = "2020-10-08"
    let sut = stringDate.toDate(withFormat: "yyyy-MM-dd")!
    XCTAssertEqual("\(sut)", "2020-10-08 05:00:00 +0000")
  }
  
  func testDefaultDateFormat() {
    let stringDate = "2020-10-07 10:45"
    let sut = stringDate.toDate()!
    XCTAssertEqual("\(sut)", "2020-10-07 15:45:00 +0000")
  }

  func testIncorrectDateFormat() {
    let stringDate = "2020-10-07"
    let sut = stringDate.toDate()
    XCTAssertNil(sut)
  }
  
}
