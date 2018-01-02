//
//  CustomEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 26/12/2017.
//

import Foundation

public protocol CustomEntityType {
    init()
    weak var rowEntity: RowEntity! { get set }
}

open class BaseCustomEntity: CustomEntityType {
    required public init() { }
    public weak var rowEntity: RowEntity!
    
    /// 在这里更新 CustomModel
    final public func update<RootType, ValueType>(_ keyPath: KeyPath<RootType, ValueType>, _ handle: (() -> Void) = { }) {
        handle()
        rowEntity.updateCustomModel(.none)
        let handIdenfitier = HandleIdentifier(type: CellEventType.custom, keyPath: keyPath)
        rowEntity.implementHandle(withIdentifier: handIdenfitier)
    }
}

