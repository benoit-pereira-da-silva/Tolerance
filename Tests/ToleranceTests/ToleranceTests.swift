import XCTest
@testable import Tolerance

final class ToleranceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Tolerance().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
