import XCTest
@testable import SwiftyForecast

class PlistFileLoaderTests: XCTestCase {
  
  func testVerboseDictionaryResult() throws {
    let sut: [String: Int] = try PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig_Test")
    XCTAssertEqual(sut["locationCount"], 22)
    XCTAssertEqual(sut["detailsInteractionCount"], 999)
    XCTAssertEqual(sut["minEnjoyableTemperatureInFahrenheit"], 100)
    XCTAssertEqual(sut["maxEnjoyableTemperatureInFahrenheit"], 1000)
  }
  
  func testDecodableReviewDesirableMomentConfigResult() throws {
    let sut: ReviewDesirableMomentConfig = try PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig_Test")
    XCTAssertEqual(sut.locationCount, 22)
    XCTAssertEqual(sut.detailsInteractionCount, 999)
    XCTAssertEqual(sut.minEnjoyableTemperatureInFahrenheit, 100)
    XCTAssertEqual(sut.maxEnjoyableTemperatureInFahrenheit, 1000)
  }
  
  func testThrowingFileNotFoundException() {
    let fileName = "not-existing-file-name-test"
    do {
      let _: [String: Int] = try PlistFileLoader.loadFile(with: fileName)
    } catch {
      switch (error as! FileLoaderError) {
      case .fileNotFound(let file):
        XCTAssertEqual(fileName, file)
        
      default:
        XCTFail()
      }
    }
  }
  
  func testThrowingIncorrectFormatException() {
    do {
      let _: [String] = try PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig_Test")
    } catch {
      switch (error as! FileLoaderError) {
      case .incorrectFormat:
        XCTAssertTrue(true)

      default:
        XCTFail()
      }
    }
  }
}
