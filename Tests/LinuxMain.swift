import XCTest

import MsgPackTests

var tests = [XCTestCaseEntry]()
tests += MsgPackTests.allTests()
XCTMain(tests)
