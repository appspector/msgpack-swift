import XCTest
import Foundation
import MsgPack

final class DecoderTests: XCTestCase {
    func testNumberArray() throws {
        
        let expected = [
            -1.5,
            -1000,
            -100,
            -10,
            -1,
            0,
            1,
            10,
            100,
            1000,
            1.5
        ]
        
        let input = Data([155, 203, 191, 248, 0, 0, 0, 0, 0, 0, 209, 252, 24, 208, 156, 246, 255, 0, 1, 10, 100, 205, 3, 232, 203, 63, 248, 0, 0, 0, 0, 0, 0])
        
        let decoder = MessagePackDecoder()
        
        let result = try decoder.decode(data: input) as! Array<AnyHashable>
        
        XCTAssertEqual(result, expected)
    }
    
    func testStringArray() throws {
        
        let expected = [
            "a",
            "aaaaaaaaaaaa",
            "qpwdokqdpokqwdpoqwdkqpwodkqwpdokqwdpoqwkqpdwokqdwpooqkwdpoqwkd"
        ]
        
        let input = Data([147, 161, 97, 172, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 217, 62, 113, 112, 119, 100, 111, 107, 113, 100, 112, 111, 107, 113, 119, 100, 112, 111, 113, 119, 100, 107, 113, 112, 119, 111, 100, 107, 113, 119, 112, 100, 111, 107, 113, 119, 100, 112, 111, 113, 119, 107, 113, 112, 100, 119, 111, 107, 113, 100, 119, 112, 111, 111, 113, 107, 119, 100, 112, 111, 113, 119, 107, 100])
        
        let decoder = MessagePackDecoder()
        
        let result = try decoder.decode(data: input) as! Array<AnyHashable>
        
        XCTAssertEqual(result, expected)
    }
    
    func testObject() throws {
        
        let expected: [String : Any?] = [
            "int": 1,
            "float": 0.5,
            "boolean": true,
            "null": nil,
            "string": "foo bar",
            "array": ["foo","bar"],
            "object": [
                "foo": 1,
                "baz": 0.5
            ]
        ]
        
        let input = Data([135, 163, 105, 110, 116, 1, 165, 102, 108, 111, 97, 116, 203, 63, 224, 0, 0, 0, 0, 0, 0, 167, 98, 111, 111, 108, 101, 97, 110, 195, 164, 110, 117, 108, 108, 192, 166, 115, 116, 114, 105, 110, 103, 167, 102, 111, 111, 32, 98, 97, 114, 165, 97, 114, 114, 97, 121, 146, 163, 102, 111, 111, 163, 98, 97, 114, 166, 111, 98, 106, 101, 99, 116, 130, 163, 102, 111, 111, 1, 163, 98, 97, 122, 203, 63, 224, 0, 0, 0, 0, 0, 0])
        
        let decoder = MessagePackDecoder()
        
        let result = try decoder.decode(data: input) as! [String : Any?]
        
        XCTAssertEqual(result["int"] as! Int, expected["int"] as! Int)
        XCTAssertEqual(result["float"] as! Float64, expected["float"] as! Float64)
        XCTAssertEqual(result["boolean"] as! Bool, expected["boolean"] as! Bool)
        XCTAssertEqual(result["null"] == nil, expected["null"]! == nil)
        XCTAssertEqual(result["string"] as! String, expected["string"] as! String)
        XCTAssertEqual(result["array"] as! Array<String>, expected["array"] as! Array<String>)
        XCTAssertEqual(result["object"] as! Dictionary<String, AnyHashable>, expected["object"] as! Dictionary<String, AnyHashable>)
    }
    
    func testPerofmance() {
        
        let input = Data([222, 0, 24, 164, 105, 110, 116, 48, 0, 164, 105, 110, 116, 49, 1, 165, 105, 110, 116, 49, 45, 255, 164, 105, 110, 116, 56, 204, 255, 165, 105, 110, 116, 56, 45, 209, 255, 1, 165, 105, 110, 116, 49, 54, 205, 1, 0, 166, 105, 110, 116, 49, 54, 45, 209, 255, 0, 165, 105, 110, 116, 51, 50, 206, 0, 1, 0, 0, 166, 105, 110, 116, 51, 50, 45, 210, 255, 255, 0, 0, 163, 110, 105, 108, 192, 164, 116, 114, 117, 101, 195, 165, 102, 97, 108, 115, 101, 194, 165, 102, 108, 111, 97, 116, 203, 63, 224, 0, 0, 0, 0, 0, 0, 166, 102, 108, 111, 97, 116, 45, 203, 191, 224, 0, 0, 0, 0, 0, 0, 167, 115, 116, 114, 105, 110, 103, 48, 160, 167, 115, 116, 114, 105, 110, 103, 49, 161, 65, 167, 115, 116, 114, 105, 110, 103, 52, 169, 102, 111, 111, 98, 97, 114, 98, 97, 122, 167, 115, 116, 114, 105, 110, 103, 56, 184, 79, 109, 110, 101, 115, 32, 118, 105, 97, 101, 32, 82, 111, 109, 97, 109, 32, 100, 117, 99, 117, 110, 116, 46, 168, 115, 116, 114, 105, 110, 103, 49, 54, 218, 2, 129, 76, 226, 128, 153, 104, 111, 109, 109, 101, 32, 110, 226, 128, 153, 101, 115, 116, 32, 113, 117, 226, 128, 153, 117, 110, 32, 114, 111, 115, 101, 97, 117, 44, 32, 108, 101, 32, 112, 108, 117, 115, 32, 102, 97, 105, 98, 108, 101, 32, 100, 101, 32, 108, 97, 32, 110, 97, 116, 117, 114, 101, 32, 59, 32, 109, 97, 105, 115, 32, 99, 226, 128, 153, 101, 115, 116, 32, 117, 110, 32, 114, 111, 115, 101, 97, 117, 32, 112, 101, 110, 115, 97, 110, 116, 46, 32, 73, 108, 32, 110, 101, 32, 102, 97, 117, 116, 32, 112, 97, 115, 32, 113, 117, 101, 32, 108, 226, 128, 153, 117, 110, 105, 118, 101, 114, 115, 32, 101, 110, 116, 105, 101, 114, 32, 115, 226, 128, 153, 97, 114, 109, 101, 32, 112, 111, 117, 114, 32, 108, 226, 128, 153, 195, 169, 99, 114, 97, 115, 101, 114, 32, 58, 32, 117, 110, 101, 32, 118, 97, 112, 101, 117, 114, 44, 32, 117, 110, 101, 32, 103, 111, 117, 116, 116, 101, 32, 100, 226, 128, 153, 101, 97, 117, 44, 32, 115, 117, 102, 102, 105, 116, 32, 112, 111, 117, 114, 32, 108, 101, 32, 116, 117, 101, 114, 46, 32, 77, 97, 105, 115, 44, 32, 113, 117, 97, 110, 100, 32, 108, 226, 128, 153, 117, 110, 105, 118, 101, 114, 115, 32, 108, 226, 128, 153, 195, 169, 99, 114, 97, 115, 101, 114, 97, 105, 116, 44, 32, 108, 226, 128, 153, 104, 111, 109, 109, 101, 32, 115, 101, 114, 97, 105, 116, 32, 101, 110, 99, 111, 114, 101, 32, 112, 108, 117, 115, 32, 110, 111, 98, 108, 101, 32, 113, 117, 101, 32, 99, 101, 32, 113, 117, 105, 32, 108, 101, 32, 116, 117, 101, 44, 32, 112, 117, 105, 115, 113, 117, 226, 128, 153, 105, 108, 32, 115, 97, 105, 116, 32, 113, 117, 226, 128, 153, 105, 108, 32, 109, 101, 117, 114, 116, 44, 32, 101, 116, 32, 108, 226, 128, 153, 97, 118, 97, 110, 116, 97, 103, 101, 32, 113, 117, 101, 32, 108, 226, 128, 153, 117, 110, 105, 118, 101, 114, 115, 32, 97, 32, 115, 117, 114, 32, 108, 117, 105, 44, 32, 108, 226, 128, 153, 117, 110, 105, 118, 101, 114, 115, 32, 110, 226, 128, 153, 101, 110, 32, 115, 97, 105, 116, 32, 114, 105, 101, 110, 46, 32, 84, 111, 117, 116, 101, 32, 110, 111, 116, 114, 101, 32, 100, 105, 103, 110, 105, 116, 195, 169, 32, 99, 111, 110, 115, 105, 115, 116, 101, 32, 100, 111, 110, 99, 32, 101, 110, 32, 108, 97, 32, 112, 101, 110, 115, 195, 169, 101, 46, 32, 67, 226, 128, 153, 101, 115, 116, 32, 100, 101, 32, 108, 195, 160, 32, 113, 117, 226, 128, 153, 105, 108, 32, 102, 97, 117, 116, 32, 110, 111, 117, 115, 32, 114, 101, 108, 101, 118, 101, 114, 32, 101, 116, 32, 110, 111, 110, 32, 100, 101, 32, 108, 226, 128, 153, 101, 115, 112, 97, 99, 101, 32, 101, 116, 32, 100, 101, 32, 108, 97, 32, 100, 117, 114, 195, 169, 101, 44, 32, 113, 117, 101, 32, 110, 111, 117, 115, 32, 110, 101, 32, 115, 97, 117, 114, 105, 111, 110, 115, 32, 114, 101, 109, 112, 108, 105, 114, 46, 32, 84, 114, 97, 118, 97, 105, 108, 108, 111, 110, 115, 32, 100, 111, 110, 99, 32, 195, 160, 32, 98, 105, 101, 110, 32, 112, 101, 110, 115, 101, 114, 32, 58, 32, 118, 111, 105, 108, 195, 160, 32, 108, 101, 32, 112, 114, 105, 110, 99, 105, 112, 101, 32, 100, 101, 32, 108, 97, 32, 109, 111, 114, 97, 108, 101, 46, 166, 97, 114, 114, 97, 121, 48, 144, 166, 97, 114, 114, 97, 121, 49, 145, 163, 102, 111, 111, 166, 97, 114, 114, 97, 121, 56, 220, 0, 21, 1, 2, 4, 8, 16, 32, 64, 204, 128, 205, 1, 0, 205, 2, 0, 205, 4, 0, 205, 8, 0, 205, 16, 0, 205, 32, 0, 205, 64, 0, 205, 128, 0, 206, 0, 1, 0, 0, 206, 0, 2, 0, 0, 206, 0, 4, 0, 0, 206, 0, 8, 0, 0, 206, 0, 16, 0, 0, 164, 109, 97, 112, 48, 128, 164, 109, 97, 112, 49, 129, 163, 102, 111, 111, 163, 98, 97, 114])
        
        let decoder = MessagePackDecoder()
        
        measure {
            for _ in (0...500000) {
                do {
                    let _ = try decoder.decode(data: input)
                } catch {
                    
                }
            }
        }
    }
    
    func testStringArrayStream() throws {
        
        let expected = [
            "a",
            "aaaaaaaaaaaa",
            "qpwdokqdpokqwdpoqwdkqpwodkqwpdokqwdpoqwkqpdwokqdwpooqkwdpoqwkd"
        ]
        
        let input = Data([147, 161, 97, 172, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 217, 62, 113, 112, 119, 100, 111, 107, 113, 100, 112, 111, 107, 113, 119, 100, 112, 111, 113, 119, 100, 107, 113, 112, 119, 111, 100, 107, 113, 119, 112, 100, 111, 107, 113, 119, 100, 112, 111, 113, 119, 107, 113, 112, 100, 119, 111, 107, 113, 100, 119, 112, 111, 111, 113, 107, 119, 100, 112, 111, 113, 119, 107, 100])
        
        let decoder = MessagePackDecoder()
        
        let stream = InputStream(data: input)
        
        stream.open()
        
        let result = try decoder.decodeOne(stream: stream, chunkSize: 16) as! Array<String>
        
        XCTAssertEqual(result, expected)
    }
    
    func testStringArrayStreamByElement() throws {
        
        let expected = [
            "a",
            "aaaaaaaaaaaa",
            "qpwdokqdpokqwdpoqwdkqpwodkqwpdokqwdpoqwkqpdwokqdwpooqkwdpoqwkd"
        ]
        
        let input = Data([147, 161, 97, 172, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 217, 62, 113, 112, 119, 100, 111, 107, 113, 100, 112, 111, 107, 113, 119, 100, 112, 111, 113, 119, 100, 107, 113, 112, 119, 111, 100, 107, 113, 119, 112, 100, 111, 107, 113, 119, 100, 112, 111, 113, 119, 107, 113, 112, 100, 119, 111, 107, 113, 100, 119, 112, 111, 111, 113, 107, 119, 100, 112, 111, 113, 119, 107, 100])
        
        let decoder = MessagePackDecoder()
        
        let stream = InputStream(data: input)
        
        stream.open()
        
        var result = Array<String>()
        
        try decoder.decodeArray(stream: stream, chunkSize: 16) { (value, total, read) in
            if let stringValue = value as? String {
                result.append(stringValue)
            }
        }
        
        XCTAssertEqual(result, expected)
    }
    
    static var allTests = [
        ("testNumberArray", testNumberArray),
        ("testStringArray", testStringArray),
        ("testObject", testObject),
        ("testPerofmance", testPerofmance),
        ("testStringArrayStream", testStringArrayStream),
        ("testStringArrayStreamByElement", testStringArrayStreamByElement)
    ]
}
