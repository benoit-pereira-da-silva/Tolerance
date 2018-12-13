//
//  JSONPatcher.swift
//  Tolerance
//
//  Created by Benoit Pereira da silva on 06/12/2017.
//  Copyright © 2017 Benoit Pereira da Silva https://bartlebys.org. All rights reserved.
//

import Foundation


public enum JSONPatcherError : Error {
    case decodingFailure(rawString: String)
    case castingFailure(rawString: String)
}

public struct JSONPatcher{

    let voidString:String = ""

    let stringEncoding:String.Encoding = .utf8

    // MARK: - Tolerant Patches

    /// Patches the data of a single object
    ///
    /// - Parameters:
    ///   - type: for a given type
    ///   - data: the daa
    /// - Returns: the patched data
    /// - Throws: ToleranceError & PatcherError^p
    public func patch<T>(_ type: T.Type, from data: Data) throws  -> Data{
        guard let TolerentType:Tolerant.Type = type as? Tolerant.Type else{
            throw ToleranceError.isNotTolerant(typeName: "\(T.self) @\(#line)")
        }
        // Patch the object
        let patchedData = try self._applyPatchOnObject(data: data, resultType:TolerentType)
        return patchedData
    }

    /// Patches the data of an array of object
    ///
    /// - Parameters:
    ///   - type: for a given type
    ///   - data: the daa
    /// - Returns: the patched data
    /// - Throws: ToleranceError & PatcherError
    public func patch<T>(_ type: [T].Type, from data: Data) throws -> Data{
        guard let TolerentType = T.self as? Tolerant.Type else{
            throw ToleranceError.isNotTolerant(typeName: "\(T.self)  @\(#line)")
        }
        let patchedData = try _applyPatchOnArrayOfObjects(data: data, resultType: TolerentType)
        return patchedData
    }


    /// Patches JSON data according to the attended Type
    ///
    /// - Parameters:
    ///   - data: the data
    ///   - resultType: the result type
    /// - Returns: the patched data
    fileprivate func _applyPatchOnObject(data: Data, resultType: Tolerant.Type) throws -> Data {
        var o: Any?
        do{
            o = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableLeaves, JSONSerialization.ReadingOptions.mutableContainers])
        }catch{
            let rawString = String(data: data, encoding: self.stringEncoding) ?? self.voidString
            throw JSONPatcherError.decodingFailure(rawString:rawString)
        }
        if var jsonDictionary = o as? Dictionary<String, Any> {
            resultType.patchDictionary(&jsonDictionary)
            return try JSONSerialization.data(withJSONObject:jsonDictionary, options:[])
        }else{
            let rawString = String(data: data, encoding: self.stringEncoding) ?? self.voidString
            throw JSONPatcherError.castingFailure(rawString: rawString)
        }
    }

    /// Patches collection of JSON data according to the attended Type
    ///
    /// - Parameters:
    ///   - data: the data
    ///   - resultType: the result type
    /// - Returns: the patched data
    fileprivate func _applyPatchOnArrayOfObjects(data: Data, resultType: Tolerant.Type) throws -> Data {

        var o:Any?
        do{
            o = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableLeaves, JSONSerialization.ReadingOptions.mutableContainers])
        }catch{
            let rawString = String(data: data, encoding: self.stringEncoding) ?? self.voidString
            throw JSONPatcherError.decodingFailure(rawString:rawString)
        }
        if var jsonObject = o as? Array<Dictionary<String, Any>>{
            var index = 0
            for var jsonElement in jsonObject {
                resultType.patchDictionary(&jsonElement)
                jsonObject[index] = jsonElement
                index += 1
            }
            return try JSONSerialization.data(withJSONObject: jsonObject, options:[])
        }else{
            let rawString = String(data: data, encoding:self.stringEncoding) ?? self.voidString
            throw JSONPatcherError.castingFailure(rawString: rawString)
        }

    }


}
