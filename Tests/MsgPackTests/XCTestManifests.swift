import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DecoderTests.allTests),
        testCase(EncoderTests.allTests)
    ]
}
#endif
