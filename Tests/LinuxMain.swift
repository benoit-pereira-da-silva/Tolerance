import XCTest

import ToleranceTests

var tests = [XCTestCaseEntry]()
tests += ToleranceTests.allTests()
XCTMain(tests)