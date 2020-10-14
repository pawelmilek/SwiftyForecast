import XCTest
@testable import SwiftyForecast

class RateLimiterTests: XCTestCase {
  
  func testFetching5MinutesBeforeIntervalLimit() {
    let today = Date()
    let date = Calendar.current.date(byAdding: .minute, value: -5, to: today)!
    let sut = RateLimiter.shouldFetch(by: date)
    XCTAssertFalse(sut)
  }

  func testFetching1MinuteAfterIntervalLimit() {
    let today = Date()
    let date = Calendar.current.date(byAdding: .minute, value: -11, to: today)!
    let sut = RateLimiter.shouldFetch(by: date)
    XCTAssertTrue(sut)
  }
  
  func testFetchingEquileToIntervalLimit() {
    let today = Date()
    let date = Calendar.current.date(byAdding: .minute, value: -10, to: today)!
    let sut = RateLimiter.shouldFetch(by: date)
    XCTAssertTrue(sut)
  }
  
  func testFetchingUnderIntervalLimit() {
    let today = Date()
    let date = Calendar.current.date(byAdding: .minute, value: 10, to: today)!
    let sut = RateLimiter.shouldFetch(by: date)
    XCTAssertFalse(sut)
  }
}
