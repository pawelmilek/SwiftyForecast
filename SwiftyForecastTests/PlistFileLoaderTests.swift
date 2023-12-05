import XCTest
@testable import SwiftyForecast

class PlistFileLoaderTests: XCTestCase {

    func testVerboseDictionaryResult() throws {
        let sut: [String: Int] = try PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig_Test")
        XCTAssertEqual(sut["locationCount"], 22)
        XCTAssertEqual(sut["enjoyableTemperatureCount"], 100)
    }

    func testDecodableReviewDesirableMomentConfigResult() throws {
        let sut = try PlistFileLoader.loadFile(
            with: "ReviewDesirableMomentConfig_Test",
            model: ReviewDesirableMomentConfig.self
        )
        XCTAssertEqual(sut.locationCount, 22)
        XCTAssertEqual(sut.enjoyableTemperatureCount, 100)
    }

    func testThrowingFileNotFoundException() {
        let fileName = "not-existing-file-name-test"
        do {
            let _: [String: Int] = try PlistFileLoader.loadFile(with: fileName)
        } catch let error as FileLoaderError {
            switch error {
            case .fileNotFound(let file):
                XCTAssertEqual(fileName, file)
            default:
                XCTFail("Inccorect exception")
            }
        } catch {
            XCTFail("Inccorect exception")
        }
    }

    func testThrowingIncorrectFormatException() {
        do {
            let _: [String] = try PlistFileLoader.loadFile(with: "ReviewDesirableMomentConfig_Test")
        } catch let error as FileLoaderError {
            switch error {
            case .incorrectFormat:
                XCTAssertTrue(true)

            default:
                XCTFail("Inccorect exception")
            }
        } catch {
            XCTFail("Inccorect exception")
        }
    }
}
