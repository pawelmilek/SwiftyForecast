import XCTest
@testable import SwiftyForecast

class ForecastRepositoryTests: XCTestCase {
  private var sut: ForecastRepository!
  
  override func setUp() {
    super.setUp()
//    sut = ForecastRepository(service: TestForecastWebService())
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  func testExample() {
    
  }
  
}
