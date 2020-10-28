import XCTest
@testable import SwiftyForecast

class CityCellViewModelTests: XCTestCase {
  private var sut: CityCellViewModel!
  
  override func setUp() {
    super.setUp()
    sut = DefaultCityCellViewModel(city: MockGenerator.generateCityDTO(), timeZoneLoader: TimeZoneLoader())
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testCityCupertinoInUnitedStates() {
    XCTAssertEqual(sut.name, "Cupertino, United States")
  }
  
  func testCity1000AMLocalTime() {
    XCTAssertEqual(sut.localTime, "10:00AM")
  }
}
