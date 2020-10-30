import XCTest
@testable import SwiftyForecast

class JSONFileLoaderTests: XCTestCase {
  
  func testThrowingFileNotFoundException() {
    let fileName = "ghost-file-not-existing"
    XCTAssertThrowsError(try JSONFileLoader.loadFile(with: fileName)) { error in
      if case let .fileNotFound(fileName) = (error as! FileLoaderError) {
        XCTAssertEqual(fileName, fileName)
      }
    }
  }
  
  func testLaodingChicagoForecast() throws {
    let sut = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
    let result = NetworkResponseParser<ForecastResponse>.parseJSON(sut)
    
    switch result {
    case .success(let data):
      XCTAssertEqual(data.compoundKey, "41.8781136|-87.6297982")
      
    default:
        XCTFail()
    }
  }
}
