import XCTest

import SwiftGestaltTests

var tests = [XCTestCaseEntry]()
tests += SwiftGestaltTests.allTests()
tests += SwiftRuntimeTests.allTests()
XCTMain(tests)
