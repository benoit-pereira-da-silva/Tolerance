//
//  Tolerant.swift
//  Tolerance
//
//  Created by Benoit Pereira da silva on 06/12/2017.
//  Copyright © 2017 Benoit Pereira da Silva https://bartlebys.org. All rights reserved.
//

import Foundation

// MARK: - The base Tolerant protocol

public protocol Tolerant {

    /// You should implement this protocol on any Codable object
    /// If you want to be able to fix conformity or versioning issues on deserialization.
    /// It enables on failure to patch the data before to retry to deserialize
    ///
    /// - Parameter dictionary: the dictionary
    static func patchDictionary(_ dictionary: inout Dictionary<String, Any>)

}

public enum ToleranceError:Error{
    case isNotTolerant(typeName:String)
}
