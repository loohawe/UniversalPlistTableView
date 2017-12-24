//
//  RowEntity+Chain.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

public typealias RowEntityHandle = (RowEntity) -> Void

internal enum CellEventType: String {
    case click
    case verified
    case custom
}

/// Let row entity can be called use chain
/// 让 Row Entity 有链式调用的功能
public protocol RowEntityChainCallable {
    
    /// Cell 中所有的回调方法
    var handleBox: HandleBox { get }
    
    /// Row click event
    @discardableResult
    func clickHandle(_ handle: @escaping RowEntityHandle) -> RowEntityChainCallable
    
    /// Row verify event
    /// Row 验证失败的 handle
    @discardableResult
    func verifyFailedHandle<RootType, ValueType>(_ keyPath: KeyPath<RootType, ValueType>, handle aHandle: @escaping (_ previousPassedValue: ValueType, _ failedValue: ValueType, _ row: RowEntity) -> Void) -> RowEntityChainCallable
    
    /// Row custom handle
    /// 一些自定义的事件回调
    @discardableResult
    func customEvent<RootType, ValueType>(_ keyPath: KeyPath<RootType, ValueType>, handle aHandle: @escaping (_ customValue: ValueType, _ row: RowEntity) -> Void) -> RowEntityChainCallable
}


extension RowEntityChainCallable where Self == RowEntity {
    
    /// Row click event
    @discardableResult
    public func clickHandle(_ handle: @escaping RowEntityHandle) -> RowEntityChainCallable {
        let identi = HandleIdentifier<Any, Any>(type: CellEventType.click, keyPath: nil)
        handleBox.update(identifier: identi, AndHandle: handle)
        return self
    }
    
    /// Row verify event
    /// Row 验证失败的 handle
    @discardableResult
    public func verifyFailedHandle<RootType, ValueType>(_ keyPath: KeyPath<RootType, ValueType>, handle aHandle: @escaping (_ previousPassedValue: ValueType, _ failedValue: ValueType, _ row: RowEntity) -> Void) -> RowEntityChainCallable {
        let identi = HandleIdentifier(type: CellEventType.verified, keyPath: keyPath)
        handleBox.update(identifier: identi, AndHandle: aHandle)
        return self
    }
    
    /// Row custom handle
    @discardableResult
    public func customEvent<RootType, ValueType>(_ keyPath: KeyPath<RootType, ValueType>, handle aHandle: @escaping (_ customValue: ValueType, _ row: RowEntity) -> Void) -> RowEntityChainCallable {
        let identi = HandleIdentifier(type: CellEventType.custom, keyPath: keyPath)
        handleBox.update(identifier: identi, AndHandle: aHandle)
        return self
    }
}
