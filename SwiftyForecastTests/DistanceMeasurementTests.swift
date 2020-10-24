import XCTest
@testable import SwiftyForecast

class DistanceMeasurementTests: XCTestCase {

    func testConvertOneMeterToCentimeters() {
      let sut = DistanceMeasurement(value: 1.0, unit: .meters)
      
      XCTAssertEqual(sut.value, 1.0)
      XCTAssertEqual(sut.converted(to: .centimeters), 100)
    }

  func testConvertOneCentimetersToMeters() {
    let sut = DistanceMeasurement(value: 1.0, unit: .centimeters)
    
    XCTAssertEqual(sut.value, 1.0)
    XCTAssertEqual(sut.converted(to: .meters), 0.01)
  }

  func testConvertFiveKilometerToMiles() {
    let sut = DistanceMeasurement(value: 5.0, unit: .kilometers)
    
    XCTAssertEqual(sut.value, 5.0)
    XCTAssertEqual(sut.converted(to: .miles), 3.1068559611866697)
  }
  
  func testConvertTeninchesToCentimeters() {
    let sut = DistanceMeasurement(value: 10.0, unit: .inches)
    
    XCTAssertEqual(sut.value, 10.0)
    XCTAssertEqual(sut.converted(to: .centimeters), 25.4)
  }
}
