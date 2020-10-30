import XCTest
@testable import SwiftyForecast

class AppStoreReviewManagerTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var sut: AppStoreReviewManager!
  
  override func setUp() {
    super.setUp()
    
    let defaultsName = "AppStoreReviewManagerTests"
    userDefaults = UserDefaults(suiteName: defaultsName)
    userDefaults.removePersistentDomain(forName: defaultsName)
    sut = AppStoreReviewManager(storage: userDefaults)
  }
  
  override func tearDown() {
    userDefaults = nil
    sut = nil
    super.tearDown()
  }
  
  func testExample() {

  }
  
}
