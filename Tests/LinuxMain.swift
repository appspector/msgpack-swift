import XCTest

import MsgPackTests

var tests = [XCTestCaseEntry]()
tests += DecoderTests.allTests()
tests += EncoderTests.allTests()
XCTMain(tests)
