import XCTest
@testable import SwiftyForecast

class ForecastRequestTests: XCTestCase {
  private var request: ForecastRequest!
  
  override func setUp() {
    super.setUp()
    request = ForecastRequest()
    request.latitude = 12.999
    request.longitude = -12.999
  }
  
  override func tearDown() {
    super.tearDown()
    request = nil
  }
  
  func testbaseURL() {
    let expected = "https://api.forecast.io"
    XCTAssertEqual(request.baseURL.absoluteString, expected)
  }
  
  func testPathWithDarkSkyAPIKey() {
    let expected = "forecast/6a92402c27dfc4740168ec5c0673a760/12.999,-12.999"
    XCTAssertEqual(request.path, expected)
  }
  
  func testRequestAbsoluteURL() {
    let expected = URL(string: "https://api.forecast.io/forecast/6a92402c27dfc4740168ec5c0673a760/12.999,-12.999")!
    XCTAssertEqual(request.urlRequest.url!.absoluteURL, expected)
  }
  
  func testParametersWithUnitsAsUSExcludeMinutelyAlertsFlags() {
    let expected = ["units": "us", "exclude": "minutely,alerts,flags"]
    XCTAssertEqual(request.parameters, expected)
  }
}
