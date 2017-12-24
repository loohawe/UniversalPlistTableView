//
//  HandleBox.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

public class HandleBox {
    
    private var _box: [AnyHashable: Any] = [:]
    
    deinit {
        _box.removeAll()
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
    
    internal func update<RootType, ValueType, ArgcTpye>(identifier: HandleIdentifier<RootType, ValueType>, AndHandle handle: @escaping (ArgcTpye) -> Void) {
        let handleModel = HandleModel(identifier: identifier, handle: handle)
        _box[identifier] = handleModel
    }
    
    internal func remove<RootType, ValueType>(identifier: HandleIdentifier<RootType, ValueType>) {
        _box.removeValue(forKey: identifier)
    }
    
    internal func clear() {
        _box.removeAll()
    }
    
    internal func implement<RootType, ValueType, ArgcTpye>(identifier: HandleIdentifier<RootType, ValueType>) -> ((ArgcTpye) -> Void)? {
        return (_box[identifier] as? HandleModel<RootType, ValueType, ArgcTpye>)?.handle
    }
}
