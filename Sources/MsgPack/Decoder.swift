import Foundation

enum MsgPackDecodingError : Error {
    case insufficientData
    case invalidMapKey(value: Any?)
    case missingMapKey
    case invalidDecodingTask
    case unrecognizedType(type: UInt8)
    case failedToDecodeString
}

enum DecodingTask {
    case Array(state: ArrayDecodingState)
    case Map(state: MapDecodingState)
}

class MapDecodingState {
    var isParsingKey: Bool = true
    var key: String? = nil
    var readCount: Int = 0
    let size: Int
    var map: Dictionary<String, Any> = Dictionary<String, Any>()
    
    init(size: Int) {
        self.size = size
        self.map.reserveCapacity(self.size)
    }
}

class ArrayDecodingState {
    let size: Int
    var array: Array<Any> = Array<Any>()
    
    init(size: Int) {
        self.size = size
        self.array.reserveCapacity(self.size)
    }
}

let DefaultDecodingStackSize = 16

public class Decoder {
    var decodingStack = Array<DecodingTask>()
    var headByte: uint8? = nil;
    var bufferReader = BufferReader()
    var extensionCodec = ExtensionCodec()
    
    init() {
        self.decodingStack.reserveCapacity(DefaultDecodingStackSize)
    }
    
    func decode(data: Data) throws -> Any? {
        bufferReader.setBuffer(data)
        return try decodeOne()
    }
    
    func decodeOne() throws -> Any? {
        var object: Any? = nil
        
        DECODING: while true {
            let headByte = try readHeadByte()
            
            if (headByte >= 0xe0) {
                // negative fixint (111x xxxx) 0xe0 - 0xff
                object = Int(headByte) - 0x100
            } else if (headByte < 0xc0) {
                if (headByte < 0x80) {
                    // positive fixint (0xxx xxxx) 0x00 - 0x7f
                    object = Int(headByte)
                } else if (headByte < 0x90) {
                    // fixmap (1000 xxxx) 0x80 - 0x8f
                    let size = Int(headByte) - 0x80
                    if size > 0 {
                        self.pushMapDecodingTask(size)
                        continue DECODING
                    } else {
                        object = Dictionary<String, Any>()
                    }
                } else if (headByte < 0xa0) {
                    // fixarray (1001 xxxx) 0x90 - 0x9f
                    let size = Int(headByte) - 0x90
                    if size > 0 {
                        self.pushArrayDecodingTask(size)
                        continue DECODING
                    } else {
                        object = Array<Any>()
                    }
                } else {
                    // fixstr (101x xxxx) 0xa0 - 0xbf
                    let size = headByte - 0xa0
                    object = try bufferReader.decodeString(size, skipHeaderSize: true)
                }
            } else {
                switch headByte {
                case 0xc0:
                    // nil
                    object = nil
                    break;
                case 0xc2:
                    // false
                    object = false
                    break;
                case 0xc3:
                    // true
                    object = true
                    break;
                // Floats
                case 0xca:
                    // float 32
                    object = try bufferReader.readFloat32()
                    break;
                case 0xcb:
                    // float 64
                    object = try bufferReader.readFloat64()
                    break;
                // Uint
                case 0xcc:
                    // uint 8
                    object = try bufferReader.readU8()
                    break;
                case 0xcd:
                    // uint 16
                    object = try bufferReader.readU16()
                    break;
                case 0xce:
                    // uint 32
                    object = try bufferReader.readU32()
                    break;
                case 0xcf:
                    // uint 64
                    object = try bufferReader.readU64()
                    break;
                // Int
                case 0xd0:
                    // int 8
                    object = try bufferReader.readI8()
                    break;
                case 0xd1:
                    // int 16
                    object = try bufferReader.readI16()
                    break;
                case 0xd2:
                    // int 32
                    object = try bufferReader.readI32()
                    break;
                case 0xd3:
                    // int 64
                    object = try bufferReader.readI64()
                    break;
                // Strings
                case 0xd9:
                    // str 8
                    let size: UInt8 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeString(size)
                    break;
                case 0xda:
                    // str 16
                    let size: UInt16 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeString(size)
                    break;
                case 0xdb:
                    // str 32
                    let size: UInt32 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeString(size)
                    break;
                // Arrays
                case 0xdc:
                    // array 16
                    let size = try bufferReader.readU16()
                    if size > 0 {
                        self.pushArrayDecodingTask(Int(size))
                        continue DECODING
                    } else {
                        object = Array<Any>()
                    }
                    break;
                case 0xdd:
                    // array 32
                    let size = try bufferReader.readU32()
                    if size > 0 {
                        self.pushArrayDecodingTask(Int(size))
                        continue DECODING
                    } else {
                        object = Array<Any>()
                    }
                    break;
                // Maps
                case 0xde:
                    // map 16
                    let size = try bufferReader.readU16()
                    if size > 0 {
                        self.pushMapDecodingTask(Int(size))
                        continue DECODING
                    } else {
                        object = Dictionary<String, Any>()
                    }
                    break;
                case 0xdf:
                    // map 32
                    let size = try bufferReader.readU32()
                    if size > 0 {
                        self.pushMapDecodingTask(Int(size))
                        continue DECODING
                    } else {
                        object = Dictionary<String, Any>()
                    }
                    break;
                // Bins
                case 0xc4:
                    // bin 8
                    let size: UInt8 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeBinary(size)
                    break;
                case 0xc5:
                    // bin 16
                    let size: UInt16 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeBinary(size)
                    break;
                case 0xc6:
                    // bin 32
                    let size: UInt32 = try bufferReader.lookInteger()
                    object = try bufferReader.decodeBinary(size)
                    break;
                // Fixext
                case 0xd4:
                    // fixext 1
                    object = try decodeExtension(1, 0)
                    break;
                case 0xd5:
                    // fixext 2
                    object = try decodeExtension(2, 0)
                    break;
                case 0xd6:
                    // fixext 4
                    object = try decodeExtension(4, 0)
                    break;
                case 0xd7:
                    // fixext 8
                    object = try decodeExtension(8, 0)
                    break;
                case 0xd8:
                    // fixext 16
                    object = try decodeExtension(16, 0)
                    break;
                // Ext
                case 0xc7:
                    // ext 8
                    let size: UInt8 = try bufferReader.lookInteger()
                    object = try decodeExtension(Int(size), 1)
                    break;
                case 0xc8:
                    // ext 16
                    let size: UInt16 = try bufferReader.lookInteger()
                    object = try decodeExtension(Int(size), 2)
                    break;
                case 0xc9:
                    // ext 32
                    let size: UInt32 = try bufferReader.lookInteger()
                    object = try decodeExtension(Int(size), 4)
                    break;
                default:
                    throw MsgPackDecodingError.unrecognizedType(type: headByte)
                }
            }
            
            self.complete()
            
            while decodingStack.count > 0 {
                let decodingTask = decodingStack.last
                
                switch decodingTask {
                case .Array(let state):
                    if let object = object {
                        state.array.append(object)
                    } else {
                        state.array.append(object as Any)
                    }
                    
                    if (state.array.count == state.size) {
                        object = state.array
                        _ = decodingStack.popLast()
                    } else {
                        continue DECODING
                    }
                case .Map(let state):
                    if state.isParsingKey {
                        if let value = object as? String {
                            state.key = value
                            state.isParsingKey = false
                            continue DECODING
                        } else {
                            throw MsgPackDecodingError.invalidMapKey(value: object)
                        }
                    } else {
                        if let key = state.key {
                            state.map[key] = object
                            state.readCount += 1
                            
                            if state.readCount == state.size {
                                object = state.map
                                _ = decodingStack.popLast()
                            } else {
                                state.key = nil
                                state.isParsingKey = true
                                continue DECODING
                            }
                        } else {
                            throw MsgPackDecodingError.missingMapKey
                        }
                    }
                    break
                case .none:
                    throw MsgPackDecodingError.invalidDecodingTask
                }
            }
            
            // Object decoded
            break
        }
        
        if let unwrappedObject = object {
            return unwrappedObject
        } else {
            return object
        }
    }
    
    func pushArrayDecodingTask(_ size: Int) {
        let newState = ArrayDecodingState(size: size)
        self.decodingStack.append(DecodingTask.Array(state: newState))
        self.complete()
    }
    
    func pushMapDecodingTask(_ size: Int) {
        let newState = MapDecodingState(size: size)
        self.decodingStack.append(DecodingTask.Map(state: newState))
        self.complete()
    }
    
    func decodeExtension(_ size: Int, _ headOffset: Int) throws -> Any? {
        let extType: Int8 = try bufferReader.lookInteger(offset: headOffset)
        let data = try bufferReader.decodeBinary(size, headerSize: headOffset + 1)
        return try extensionCodec.decode(bytes: data, type: extType)
    }
    
    func readHeadByte() throws -> uint8 {
        if self.headByte == nil {
            self.headByte = try self.bufferReader.readU8()
        }
        
        return self.headByte!
    }
    
    func complete() {
        self.headByte = nil
    }
}
