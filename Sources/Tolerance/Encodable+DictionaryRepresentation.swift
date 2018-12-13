//
//  Encodable+DictionaryRepresentation.swift
//  BartlebyCore
//
//  Created by  Benoit Pereira da Silva on 05/12/2017.
//  Copyright © 2017 Benoit Pereira da Silva https://bartlebys.org. All rights reserved.
//

import Foundation

public extension Encodable{

    /// Returns a dictionary representation of the Model
    ///
    /// - Returns: the dictionary
    public func toDictionaryRepresentation() throws -> Dictionary<String, Any> {

        let data = try JSONEncoder().encode(self)
        if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
            return dictionary
        }else{
            return Dictionary<String, Any>()
        }
    }
}
