import XCTest
@testable import SwiftyForecast

class ContentViewModelTests: XCTestCase {
  private var sut: ContentViewModel!
  private var httpClient: HttpClient<ForecastResponse>!
  private var testService: TestForecastService!
  private var repository: Repository!
  
  override func setUp() {
    super.setUp()

    httpClient = HttpClient(session: URLSessionMock())
    testService = TestForecastService(httpClient: httpClient, request: TestForecastWebRequest())
    testService.successCompletion = .success(MockGenerator.generateForecast()!)
    
    repository = TestRepository(service: testService, dataAccessObject: TestForecastDAO())
    sut = DefaultContentViewModel(city: MockGenerator.generateCityDTO(), repository: repository)
  }
  
  override func tearDown() {
    super.tearDown()
    
    httpClient = nil
    testService = nil
    repository = nil
    sut = nil
  }
  
  func testSuccessfullyLoadedData() {
    var isSuccess = false
    
    sut.onSuccess = {
      isSuccess = true
    }
    
    sut.loadData()
    XCTAssertTrue(isSuccess, "Unable to load content data successfully")
  }
  
  func testForecastDataFor24Hours() {
    sut.loadData()
    
    let numberOfHours = sut.hourly!.data.count
    let expectedNumberOfHourlyData = 24
    XCTAssertEqual(numberOfHours, expectedNumberOfHourlyData)
  }
  
  func testFirstHourData() {
    sut.loadData()
    
    let data = sut.hourly!.data.first!
    let date = data.date
    let summary = data.summary
    let icon = data.icon
    let temperature = data.temperature
    
    XCTAssertEqual("\(date)", "2019-04-27 20:00:00 +0000")
    XCTAssertEqual(summary, "Light Sleet")
    XCTAssertEqual(icon, "sleet")
    XCTAssertEqual(temperature, 33.59)
  }
  
  func testLastHourData() {
    sut.loadData()
    
    let data = sut.hourly!.data.last!
    let date = data.date
    let summary = data.summary
    let icon = data.icon
    let temperature = data.temperature
    
    XCTAssertEqual("\(date)", "2019-04-28 19:00:00 +0000")
    XCTAssertEqual(summary, "Clear")
    XCTAssertEqual(icon, "clear-day")
    XCTAssertEqual(temperature, 46.67)
  }

  func testAttributedStringIcon() {
    sut.loadData()
    
    let forecast = MockGenerator.generateForecast()!
    let icon = forecast.currently!.icon
    let font = Style.CurrentForecast.conditionFontIconSize
    let expectedAttributedIcon = ConditionFontIcon.make(icon: icon, font: font)?.attributedIcon
    
    XCTAssertEqual(sut.icon, expectedAttributedIcon)
  }
  
  func testSaturdayApril27WeekdayMonthDayFormat() {
    sut.loadData()
    XCTAssertEqual(sut.weekdayMonthDay, "SATURDAY, APRIL 27")
  }
  
  func testCupertinoAsCityName() {
    sut.loadData()
    XCTAssertEqual(sut.cityName, "Cupertino")
  }
  
  func testTemperatureOfOneCelsius() {
    sut.loadData()

    let notationController = NotationController()
    notationController.temperatureNotation = .celsius

    XCTAssertEqual(sut.temperature, "1°")
  }
  
  func testFahrenheitTemperature() {
    sut.loadData()

    let notationController = NotationController()
    notationController.temperatureNotation = .fahrenheit
    
    XCTAssertEqual(sut.temperature, "34°")
  }
}
