import XCTest
@testable import SwiftyForecast

class DailyForecastTests: XCTestCase {
  private var dailyForecast: DailyForecastDTO!
  private var viewModel: DailyCellViewModel!
  
  override func setUp() {
    super.setUp()
    
    dailyForecast = MockGenerator.generateDailyForecast()
    let data = dailyForecast.sevenDaysData.first!
    viewModel = DefaultDailyCellViewModel(dailyData: data)
  }
  
  override func tearDown() {
    super.tearDown()
    
    dailyForecast = nil
    viewModel = nil
  }
  
  func testDailySummary() {
    XCTAssertEqual(dailyForecast.summary, "Rain today through Thursday, with high temperatures rising to 64°F on Thursday.")
  }
  
  func testDailyIcon() {
    XCTAssertEqual(dailyForecast.icon, "rain")
  }
  
  func testDailyAttributedDate() {
    var timeInterval: TimeInterval {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd/yyyy"
      let date = formatter.date(from: "04/28/2019")
      return date?.timeIntervalSince1970 ?? 0
    }
    
    let forecastDate = Date(timeIntervalSince1970: timeInterval) // SUNDAY APRIL 28
    let expectedValue = DailyDateRenderer.render(forecastDate)
    XCTAssertEqual(viewModel.attributedDate, expectedValue)
  }
  
  func testDailyConditionIcon() {
    let expectedValue = ConditionFontIcon.make(icon: "partly-cloudy-night", font: 22)!.attributedIcon
    XCTAssertEqual(viewModel.conditionIcon!, expectedValue)
  }
  
  func testDailySevenDaysForecast() {
    XCTAssertEqual(dailyForecast.sevenDaysData.count, 7)
  }
}
