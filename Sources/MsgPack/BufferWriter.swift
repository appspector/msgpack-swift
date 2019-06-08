//
//  File.swift
//  
//
//  Created by zen on 6/8/19.
//

import Foundation

class BufferWriter {
    
    private var buffer = Data()
    
    func getBuffer() -> Data {
        return buffer
    }
    
    // Uint
    
    func write<T: FixedWidthInteger>(intValue: T) throws -> Void {
        var value = intValue.bigEndian
        let data = Data(bytes: &value, count: MemoryLayout<T>.size)
        buffer.append(data)
    }
    
    func write(uint8: UInt8) throws -> Void {
        try write(intValue: uint8)
    }
    
    func write(uint16: UInt16) throws -> Void {
        try write(intValue: uint16)
    }
    
    func write(uint32: UInt32) throws -> Void {
        try write(intValue: uint32)
    }
    
    func write(uint64: UInt64) throws -> Void {
        try write(intValue: uint64)
    }
    
    // Int
    
    func write(int8: Int8) throws -> Void {
        try write(intValue: int8)
    }
    
    func write(int16: Int16) throws -> Void {
        try write(intValue: int16)
    }
    
    func write(int32: Int32) throws -> Void {
        try write(intValue: int32)
    }
    
    func write(int64: Int64) throws -> Void {
        try write(intValue: int64)
    }
    
    // Floats
    
    func write(float32: Float32) throws -> Void {
        try write(uint32: float32.bitPattern)
    }
    
    func write(float64: Float64) throws -> Void {
        try write(uint64: float64.bitPattern)
    }
    
    func writeRaw(data: Data) throws -> Void {
        buffer.append(data)
    }
}
