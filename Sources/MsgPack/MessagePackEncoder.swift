//
//  File.swift
//  
//
//  Created by zen on 6/7/19.
//

import Foundation

public enum MessagePackEncodingError : Error {
    case unsupportedValue(value: Any?)
    case stringIsTooLong(value: Int)
    case arrayIsTooLong(value: Int)
    case mapIsTooLong(value: Int)
    case failedToEncodeString(value: String)
}

public class MessagePackEncoder {
    var bufferWriter = BufferWriter()
    var extensionCodec = ExtensionCodec()
    
    public init() {}
    
    public func getBuffer() -> Data {
        return bufferWriter.getBuffer()
    }
    
    public func encode(value: Any?) throws -> Void {
        if let value = value {
            switch value {
            case let value as String:
                try encode(string: value)
            
            case let value as Bool:
                try encode(bool: value)
            
            case let value as UInt:
                try encode(uint: value)
            case let value as UInt8:
                try encode(uint8: value)
            case let value as UInt16:
                try encode(uint16: value)
            case let value as UInt32:
                try encode(uint32: value)
            case let value as UInt64:
                try encode(uint64: value)
                
            case let value as Int:
                try encode(int: value)
            case let value as Int8:
                try encode(int8: value)
            case let value as Int16:
                try encode(int16: value)
            case let value as Int32:
                try encode(int32: value)
            case let value as Int64:
                try encode(int64: value)
                
            case let value as Float32:
                try encode(float32: value)
            case let value as Float64:
                try encode(float64: value)
                
            case let value as Dictionary<String, Any?>:
                try encode(map: value)
            case let value as Array<Any?>:
                try encode(array: value)
            default:
                if let ext = try extensionCodec.encode(value: value) {
                    try encode(ext: ext)
                } else {
                    throw MessagePackEncodingError.unsupportedValue(value: value)
                }
            }
        } else {
            try encodeNil()
        }
    }
    
    func encode(ext: Any) throws -> Void {
        try bufferWriter.write(uint8: 0xc0)
    }
    
    public func encodeNil() throws -> Void {
        try bufferWriter.write(uint8: 0xc0)
    }
    
    public func encode(string: String) throws -> Void {
        let utf8Count = string.utf8.count
        try encodeStringHeader(size: utf8Count)
                
        if let stringData = string.data(using: .utf8) {
            try bufferWriter.writeRaw(data: stringData)
        } else {
            throw MessagePackEncodingError.failedToEncodeString(value: string)
        }
    }
    
    private func encodeStringHeader(size: Int) throws -> Void {
        if size < 32 {
            try bufferWriter.write(uint8: UInt8(0xa0 + size))
        } else if size < 0x100 {
            try bufferWriter.write(uint8: 0xd9)
            try bufferWriter.write(uint8: UInt8(size))
        } else if size < 0x10000 {
            try bufferWriter.write(uint8: 0xda)
            try bufferWriter.write(uint16: UInt16(size))
        } else if size < 0x100000000 {
            try bufferWriter.write(uint8: 0xdb)
            try bufferWriter.write(uint32: UInt32(size))
        } else {
            throw MessagePackEncodingError.stringIsTooLong(value: size)
        }
    }
    
    public func encode(bool: Bool) throws -> Void {
        if bool {
            try bufferWriter.write(uint8: 0xc3)
        } else {
            try bufferWriter.write(uint8: 0xc2)
        }
    }
    
    // Uint
    
    public func encode(uint: UInt) throws -> Void {
        let uintSize = MemoryLayout<UInt>.size
        let uint32Size = MemoryLayout<UInt32>.size
        
        if uintSize == uint32Size {
            try encode(uint32: UInt32(uint))
        } else {
            try encode(uint64: UInt64(uint))
        }
    }
    
    public func encode(uint8: UInt8) throws -> Void {
        if uint8 < 0x80 {
          try bufferWriter.write(uint8: uint8)
        } else {
          try bufferWriter.write(uint8: 0xcc)
          try bufferWriter.write(uint8: uint8)
        }
    }
    
    public func encode(uint16: UInt16) throws -> Void {
        try bufferWriter.write(uint8: 0xcd)
        try bufferWriter.write(uint16: uint16)
    }
    
    public func encode(uint32: UInt32) throws -> Void {
        try bufferWriter.write(uint8: 0xce)
        try bufferWriter.write(uint32: uint32)
    }
    
    public func encode(uint64: UInt64) throws -> Void {
        try bufferWriter.write(uint8: 0xcf)
        try bufferWriter.write(uint64: uint64)
    }
    
    // Int
    
    public func encode(int: Int) throws -> Void {
        let intSize = MemoryLayout<Int>.size
        let int32Size = MemoryLayout<Int32>.size
        
        if intSize == int32Size {
            try encode(int32: Int32(int))
        } else {
            try encode(int64: Int64(int))
        }
    }
    
    public func encode(int8: Int8) throws -> Void {
        if int8 >= 0 {
            try bufferWriter.write(int8: int8)
        } else if int8 >= -0x20 {
            try bufferWriter.write(uint8: UInt8(0xe0))
        } else {
            try bufferWriter.write(uint8: 0xd0)
            try bufferWriter.write(int8: int8)
        }
    }
    
    public func encode(int16: Int16) throws -> Void {
        try bufferWriter.write(uint8: 0xd1)
        try bufferWriter.write(int16: int16)
    }
    
    public func encode(int32: Int32) throws -> Void {
        try bufferWriter.write(uint8: 0xd2)
        try bufferWriter.write(int32: int32)
    }
    
    public func encode(int64: Int64) throws -> Void {
        try bufferWriter.write(uint8: 0xd3)
        try bufferWriter.write(int64: int64)
    }
    
    // Floats
    
    public func encode(float32: Float32) throws -> Void {
        try bufferWriter.write(uint8: 0xca)
        try bufferWriter.write(float32: float32)
    }
    
    public func encode(float64: Float64) throws -> Void {
        try bufferWriter.write(uint8: 0xcb)
        try bufferWriter.write(float64: float64)
    }
    
    // Map
    
    private func encodeMapHeader(size: Int) throws -> Void {
        if size < 16 {
            try bufferWriter.write(uint8: UInt8(0x80 + size))
        } else if size < 0x10000 {
            try bufferWriter.write(uint8: 0xde)
            try bufferWriter.write(uint16: UInt16(size))
        } else if size < 0x100000000 {
            try bufferWriter.write(uint8: 0xdf)
            try bufferWriter.write(uint32: UInt32(size))
        } else {
            throw MessagePackEncodingError.mapIsTooLong(value: size)
        }
    }
    
    public func encode(map: Dictionary<String, Any?>) throws -> Void {
        try encodeMapHeader(size: map.count)
        
        let sortedKeys = map.keys.sorted()
        
        for key in sortedKeys {
            try encode(string: key)
            try encode(value: map[key] as Any?)
        }
    }
    
    // Array
    
    private func encodeArrayHeader(size: Int) throws -> Void {
        if size < 16 {
            try bufferWriter.write(uint8: UInt8(0x90 + size))
        } else if size < 0x10000 {
            try bufferWriter.write(uint8: 0xdc)
            try bufferWriter.write(uint16: UInt16(size))
        } else if size < 0x100000000 {
            try bufferWriter.write(uint8: 0xdd)
            try bufferWriter.write(uint32: UInt32(size))
        } else {
            throw MessagePackEncodingError.arrayIsTooLong(value: size)
        }
    }
    
    public func encode(array: Array<Any?>) throws -> Void {
        try encodeArrayHeader(size: array.count)
        
        for item in array {
            try encode(value: item)
        }
    }
    
}
