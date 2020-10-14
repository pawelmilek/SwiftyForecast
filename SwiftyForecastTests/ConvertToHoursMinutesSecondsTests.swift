import XCTest
@testable import SwiftyForecast

class ConvertToHoursMinutesSecondsTests: XCTestCase {
  
  func testConvertSecondsToOneHourZeroMinutsZeroSeconds() {
    let sut = 3600
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.hours, 1)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.minutes, 0)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.seconds, 0)
  }
  
  func testConvertSecondsToTwoHourZeroMinutsZeroSeconds() {
    let sut = 7200
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.hours, 2)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.minutes, 0)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.seconds, 0)
  }
  
  func testConvertSecondsToThreeHourSixMinutsFortySeconds() {
    let sut = 7600
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.hours, 2)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.minutes, 6)
    XCTAssertEqual(sut.convertToHoursMinutesSeconds.seconds, 40)
  }
}
