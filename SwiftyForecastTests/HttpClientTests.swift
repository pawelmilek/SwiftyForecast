import XCTest
@testable import SwiftyForecast

class HttpClientTests: XCTestCase {
  private var httpClient: HttpClient<[String: String]>!
  private var session: URLSessionMock!
  
  override func setUp() {
    super.setUp()
    session = URLSessionMock()
    httpClient = HttpClient(session: session)
  }
  
  override func tearDown() {
    super.tearDown()
    
    session = nil
    httpClient = nil
  }
  
  func testGetRequestSuccessResult() {
    let webRequest = TestForecastWebRequest()
    let expectedResult = ["summary": "Mixed precipitation throughout the day."]
    let data = try! JSONSerialization.data(withJSONObject: expectedResult, options: .prettyPrinted)
    
    session.data = data
    
    var requestResult: [String: String]!
    
    httpClient.get(by: webRequest) { result in
      switch result {
      case .success(let data):
        requestResult = data
        
      case .failure:
        requestResult = nil
      }
    }
    
    XCTAssertEqual(requestResult, expectedResult)
  }
  
  func testGetRequestFailureResult() {
    let webRequest = TestForecastWebRequest()
    session.data = nil
    
    var requestResult: WebServiceError!
    
    httpClient.get(by: webRequest) { result in
      switch result {
      case .success:
        requestResult = nil
        
      case .failure(let error):
        requestResult = error
      }
    }
    
    XCTAssertNotNil(requestResult)
  }

}
