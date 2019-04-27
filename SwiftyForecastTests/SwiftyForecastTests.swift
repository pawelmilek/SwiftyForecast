import XCTest

class SwiftyForecastTests: XCTestCase {
  var hourlyDataViewModel: HourlyDataViewModel!
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    
    hourlyDataViewModel = nil
  }
  
  func testHourlyForecast() {
    let hourlyData = ForecastGenerator.generateHourlyForecast().data.first
    hourlyDataViewModel = DefaultHourlyDataViewModel(hourlyData: hourlyData!)
  }
  
  func testTemperatureRoundedToString() {
//    let belowZero = -0.4
//    belowZero.asString
    
    // when: -0.4
    // then: -1
  }
  
}
