//
//  FunctionModel.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

internal struct HandleIdentifier<RootType, ValueType>: Hashable, Equatable {
    
    var hashValue: Int {
        let string = keyPath == nil ? "\(type.rawValue)" : "\(type.rawValue)\(keyPath!.hashValue)"
        debugPrint(string)
        return string.hashValue
    }
    
    static func ==(lhs: HandleIdentifier<RootType, ValueType>, rhs: HandleIdentifier<RootType, ValueType>) -> Bool {
        return lhs.type == rhs.type && lhs.keyPath == rhs.keyPath
    }
    
    internal let type: CellEventType
    internal let keyPath: KeyPath<RootType, ValueType>?
    
    internal static func clickIdentifier() -> HandleIdentifier<Any, Any> {
        return HandleIdentifier<Any, Any>(type: CellEventType.click, keyPath: nil)
    }
}

internal struct HandleModel<RootType, ValueType, ArgcType> {
    internal let identifier: HandleIdentifier<RootType, ValueType>
    internal let handle: (ArgcType) -> Void
}
