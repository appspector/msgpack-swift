//
//  File.swift
//  
//
//  Created by zen on 6/6/19.
//

import Foundation

class BufferReader {
    var buffer: Data = Data()
    var position: Int = 0
    
    func setBuffer(_ data: Data) {
        self.buffer = data
    }
    
    func append(data: Data) {
        self.buffer.append(data)
    }    
    
    func hasRemaining(_ size: Int) throws {
        if position + size > buffer.count {
            throw MessagePackDecodingError.insufficientData
        }
    }
    
    func decodeBinary<T: FixedWidthInteger>(_ size: T, headerSize: Int? = nil) throws-> Data {
        
        if size == 0 {
            return Data()
        }
        
        var headerOffset = 0
        
        if let headerSize = headerSize {
            headerOffset = headerSize
        } else {
            headerOffset = MemoryLayout<T>.size
        }
        
        let intSize = Int(size)
        let offset = position + headerOffset
        let end = offset + intSize
        
        try hasRemaining(intSize - headerOffset)
        
        let value = buffer.subdata(in: Range.init((offset...end - 1)))
        
        position = position + headerOffset + intSize
        
        return value
    }
    
    func decodeString<T: FixedWidthInteger>(_ size: T, skipHeaderSize: Bool = false) throws -> String {
        if size == 0 {
            return ""
        }
        
        let headerOffset = skipHeaderSize ? 0 : MemoryLayout<T>.size
        let intSize = Int(size)
        let offset = position + headerOffset
        let end = offset + intSize
        
        try hasRemaining(intSize - headerOffset)
        
        let value = try buffer.withUnsafeBytes { (bytes) -> String in
            let stringBytes = UnsafeMutableBufferPointer<CChar>.allocate(capacity: intSize + 1)
            
            bytes.copyBytes(to: stringBytes, from: (offset...end - 1))
            
            stringBytes[stringBytes.count - 1] = 0
            
            let stringBase = stringBytes.baseAddress!
            
            let string = String(validatingUTF8: stringBase)
            
            stringBytes.deallocate()
            
            if let string = string {
                return string
            } else {
                throw MessagePackDecodingError.failedToDecodeString
            }
        }
        
        position = position + headerOffset + intSize
        
        return value
    }
    
    func lookInteger<T: FixedWidthInteger>(offset: Int = 0) throws -> T {
        try hasRemaining(MemoryLayout<T>.size)
        
        let number = buffer.withUnsafeBytes { (bytes) -> T in
            let base = bytes.baseAddress!
            let poiner = base.advanced(by: position + offset).assumingMemoryBound(to: T.self)
            return poiner.pointee.bigEndian
        }
        
        return number
    }
    
    func readInteger<T: FixedWidthInteger>() throws -> T {
        let number: T = try lookInteger()
        
        position = position + MemoryLayout<T>.size
        
        return number
    }
    
    func readFloat32() throws -> Float32 {
        try hasRemaining(MemoryLayout<Float32>.size)
        
        let intNumber = buffer.withUnsafeBytes { (bytes) -> UInt32 in
            let base = bytes.baseAddress!
            let poiner = base.advanced(by: position).assumingMemoryBound(to: UInt32.self)
            return poiner.pointee.bigEndian
        }
        
        let number = Float32(bitPattern: intNumber)
        
        position = position + MemoryLayout<Float32>.size
        
        return number
    }
    
    func readFloat64() throws -> Float64 {
        try hasRemaining(MemoryLayout<Float64>.size)
        
        let intNumber = buffer.withUnsafeBytes { (bytes) -> UInt64 in
            let base = bytes.baseAddress!
            let poiner = base.advanced(by: position).assumingMemoryBound(to: UInt64.self)
            return poiner.pointee.bigEndian
        }
        
        let number = Float64(bitPattern: intNumber)
        
        position = position + MemoryLayout<Float64>.size
        
        return number
    }
    
    func readU8() throws -> uint8 {
        return try readInteger()
    }
    
    func readU16() throws -> UInt16 {
        return try readInteger()
    }
    
    func readU32() throws -> uint32 {
        return try readInteger()
    }
    
    func readU64() throws -> uint64 {
        return try readInteger()
    }
    
    func readI8() throws -> Int8 {
        return try readInteger()
    }
    
    func readI16() throws -> Int16 {
        return try readInteger()
    }
    
    func readI32() throws -> Int32 {
        return try readInteger()
    }
    
    func readI64() throws -> Int64 {
        return try readInteger()
    }
}
