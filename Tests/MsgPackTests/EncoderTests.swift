import XCTest
import Foundation
import MsgPack

func printData(_ data: Data) -> String {
    var value = "["
    
    let formattedBytes = data.map { (byte) in
        String(format: "%d", byte)
    }
    
    value += formattedBytes.joined(separator: ",")
    
    value += "]"
    
    return value
}

final class EncoderTests: XCTestCase {
    
    var encoder = MessagePackEncoder()
    
    override func setUp() {
        encoder = MessagePackEncoder()
    }
    
    func testNilEncode() throws {
        try encoder.encode(value: nil)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([192]))
    }
    
    func testTrueEncode() throws {
        try encoder.encode(value: true)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([195]))
    }
    
    func testFalseEncode() throws {
        try encoder.encode(value: false)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([194]))
    }
    
    func testStringEncode() throws {
        try encoder.encode(value: "test")
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([164, 116, 101, 115, 116]))
    }
    
    func testLargeStringEncode() throws {
        try encoder.encode(value: "pokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpokpokpokpokpokpokpokpookpokpokpokpokpokpokpok")
        
        let result = encoder.getBuffer()
        
        let expected = Data([218, 2, 90, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107, 112, 111, 107])
        
        XCTAssertEqual(result, expected)
    }
    
    func testUint8Encode() throws {
        try encoder.encode(value: UInt8(10))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([10]))
    }
    
    func testUint16Encode() throws {
        try encoder.encode(value: UInt16(1000))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([205, 3, 232]))
    }
    
    func testUint32Encode() throws {
        try encoder.encode(value: UInt32(1000000))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([206, 0, 15, 66, 64]))
    }
    
    func testUint64Encode() throws {
        try encoder.encode(value: UInt64(1000000000000))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([207, 0, 0, 0, 232, 212, 165, 16, 0]))
    }
    
    func testFloat32Encode() throws {
        try encoder.encode(value: Float32(1000.12))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([202, 68, 122, 7, 174]))
    }
    
    func testFloat64Encode() throws {
        try encoder.encode(value: Float64(10000000000000000.5689))
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([203, 67, 65, 195, 121, 55, 224, 128, 0]))
    }
    
    func testIntArrayEncode() throws {
        try encoder.encode(value: [1,2,3,4,5] as Array<Int8>)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([149, 1, 2, 3, 4, 5]))
    }
    
    func testUInt16ArrayEncode() throws {
        try encoder.encode(value: [1000,2000,3000,4000,5000] as Array<UInt16>)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([149, 205, 3, 232, 205, 7, 208, 205, 11, 184, 205, 15, 160, 205, 19, 136]))
    }
    
    func testInt16ArrayEncode() throws {
        try encoder.encode(value: [-1000,-2000,-3000,-4000,-5000] as Array<Int16>)
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([149, 209, 252, 24, 209, 248, 48, 209, 244, 72, 209, 240, 96, 209, 236, 120]))
    }
    
    func testStringArrayEncode() throws {
        try encoder.encode(value: ["a", "bddqwdqwdqwd", "qwpodkqdpokqwdpoqwkdpqwodkqwdpok"])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([147, 161, 97, 172, 98, 100, 100, 113, 119, 100, 113, 119, 100, 113, 119, 100, 217, 32, 113, 119, 112, 111, 100, 107, 113, 100, 112, 111, 107, 113, 119, 100, 112, 111, 113, 119, 107, 100, 112, 113, 119, 111, 100, 107, 113, 119, 100, 112, 111, 107]))
    }
    
    func testMixedArrayEncode() throws {
        try encoder.encode(value: ["a", UInt8(10), true])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([147, 161, 97, 10, 195]))
    }
    
    func testEmptyMapEncode() throws {
        try encoder.encode(value: Dictionary<String, Any?>())
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([128]))
    }
    
    func testMapEncode() throws {
        try encoder.encode(value: ["value" : UInt8(1)])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([129, 165, 118, 97, 108, 117, 101, 1]))
    }
    
    func testNestedArrayMapEncode() throws {
        try encoder.encode(value: [
            "array" : [1,2,3] as Array<UInt8>,
        ])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([129, 165, 97, 114, 114, 97, 121, 147, 1, 2, 3]))
    }
    
    func testNestedMapEncode() throws {
        try encoder.encode(value: [
            "nested" : ["isActive": true]
            ])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([129, 166, 110, 101, 115, 116, 101, 100, 129, 168, 105, 115, 65, 99, 116, 105, 118, 101, 195]))
    }
    
    func testComplexMapEncode() throws {
        try encoder.encode(value: [
            "value" : UInt8(1),
            "array" : [1,2,3] as Array<UInt8>,
            "nested" : ["isActive": true]
        ])
        
        let result = encoder.getBuffer()
        
        XCTAssertEqual(result, Data([131, 165, 97, 114, 114, 97, 121, 147, 1, 2, 3, 166, 110, 101, 115, 116, 101, 100, 129, 168, 105, 115, 65, 99, 116, 105, 118, 101, 195, 165, 118, 97, 108, 117, 101, 1]))
    }
    
    func testUnsupportedObjectEncode() throws {
        XCTAssertThrowsError(try encoder.encode(value: InputStream()))
    }
    
    func testEncodePerformance() throws {
        
        let value = [
            "value" : UInt8(1),
            "array" : [1,2,3] as Array<UInt8>,
            "nested" : ["isActive": true]
        ] as Dictionary<String, Any?>
        
        measure {
            for _ in (0...5000) {
                do {
                    let _ = try encoder.encode(value: value)
                } catch {
                    
                }
            }
        }
    }
    
    static var allTests = [
        ("testNilEncoder", testNilEncode),
        ("testStringEncode", testStringEncode),
        ("testLargeStringEncode", testLargeStringEncode),
        ("testUint8Encode", testUint8Encode),
        ("testUint16Encode", testUint16Encode),
        ("testUint32Encode", testUint32Encode),
        ("testUint64Encode", testUint64Encode)
    ]
}
