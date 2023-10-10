import XCTest

class CollectionSafeSubscriptTests: XCTestCase {
    private var collection: [Int]!

    override func setUp() {
        super.setUp()
        collection = [1, 2, 3, 4, 5, 6]
    }

    override func tearDown() {
        super.tearDown()
        collection = nil
    }

    func testCollectionWithDefaultValue() {
        let value = collection[safe: -1, default: 99]
        let expectedValue = 99
        XCTAssertEqual(value, expectedValue)
    }

    func testCollectionWithDefaultValueIfNeeded() {
        let value = collection[safe: 5, default: 0]
        let expectedValue = 6
        XCTAssertEqual(value, expectedValue)
    }

    func testCollectionValue() {
        let value = collection[safe: 0]
        let expectedValue = 1
        XCTAssertEqual(value, expectedValue)
    }

    func testCollectionSubscriptOptionalCoalescing() {
        let value = collection[safe: -5] ?? -100
        let expectedValue = -100
        XCTAssertEqual(value, expectedValue)
    }

}
