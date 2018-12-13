//
//  JSONCoder.swift
//  Tolerance
//
//  Created by Benoit Pereira da silva on 06/12/2017.
//  Copyright © 2017 Benoit Pereira da Silva https://bartlebys.org. All rights reserved.
//

import Foundation

// Tolerant Json encoder and decoder
public struct JSONCoder: ConcreteCoder{

    static public var encoder:JSONEncoder = JSON.encoder

    static public var decoder:JSONDecoder = JSON.decoder

    fileprivate static let patcher:JSONPatcher = JSONPatcher()

    // MARK : - ConcreteCoder
    /// Encodes the given top-level value and returns its representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Data` value containing the encoded data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    public static func encode<T : Encodable>(_ value: T) throws -> Data{
        return try JSONCoder.encoder.encode(value)
    }

    // MARK : - ConcreteDecoder

    /// Decodes a top-level value of the given type from the given  representation.
    /// If the decoding fails it tries to patch the data
    ///
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid .
    /// - throws: An error if any value throws an error during decoding.
    public static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do{
            // Try a to decode normally
            return try JSONCoder.decoder.decode(T.self, from: data)
        }catch{
            // Try to patch on failure
            let patchedData = try self.patcher.patch(T.self, from: data)
            return try JSONCoder.decoder.decode(T.self, from: patchedData)
        }
    }


    /// Decodes a top-level array of value of the given type from the given  representation.
    ///
    /// - parameter type: The  type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid .
    /// - throws: An error if any value throws an error during decoding.
    public static func decode<T>(_ type: [T].Type, from data: Data) throws -> [T] where T : Decodable{
        do{
            // Try a to decode normally
            return try JSONCoder.decoder.decode([T].self, from: data)
        }catch{
            let patchedData = try self.patcher.patch([T].self, from: data)
            return try JSONCoder.decoder.decode([T].self, from: patchedData)
        }
    }

    public init(){}

}
