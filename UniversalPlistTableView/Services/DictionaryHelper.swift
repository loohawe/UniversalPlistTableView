//
//  DictionaryHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    mutating func fetchValueAndRemove<ValueType>(withKey key: String) -> ValueType? {
        if let tmpValue = self[key] as? ValueType {
            self.removeValue(forKey: key)
            return tmpValue
        }
        return nil
    }
}
