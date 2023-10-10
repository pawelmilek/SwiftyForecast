import XCTest
@testable import SwiftyForecast

class DailyCellViewModelTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var notationController: NotationController!
  private var sut: DailyCellViewModelProtocol!

  override func setUp() {
    super.setUp()
    let defaultsName = "DailyCellViewModelTests"
    userDefaults = UserDefaults(suiteName: defaultsName)
    userDefaults.removePersistentDomain(forName: defaultsName)
    notationController = NotationController(storage: userDefaults)

    let currentDayData = MockGenerator.generateDailyForecast().currentDayData
    sut = DailyCellViewModel(dailyData: currentDayData, notationController: notationController)
  }

  override func tearDown() {
    userDefaults = nil
    notationController = nil
    sut = nil
    super.tearDown()
  }

  func testAttributedDate() {
    let currentDayDate = MockGenerator.generateDailyForecast().currentDayData.date
    let exptected = DailyDateRenderer.render(currentDayDate)
    XCTAssertEqual(sut.attributedDate, exptected)
  }

  func testConditionIcon() {
    let dailyIcon = MockGenerator.generateDailyForecast().currentDayData.icon
    let expected = ConditionFontIcon.make(icon: dailyIcon, font: Style.DailyCell.conditionIconSize)?.attributedIcon
    XCTAssertEqual(sut.conditionIcon, expected)
  }

  func testTemperatureMinMaxInFahrenheit() {
    notationController.temperatureNotation = .fahrenheit
    XCTAssertEqual(sut.temperatureMax, "52°")
    XCTAssertEqual(sut.temperatureMin, "34°")
  }

  func testTemperatureMinMaxInCelsius() {
    notationController.temperatureNotation = .celsius
    XCTAssertEqual(sut.temperatureMax, "11°")
    XCTAssertEqual(sut.temperatureMin, "1°")
  }
}
