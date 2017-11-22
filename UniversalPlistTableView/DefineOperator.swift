//
//  DefineOperator.swift
//  UniversalPlistTableView
//
//  Created by luhao on 22/11/2017.
//

import UIKit
import RxSwift
import RxCocoa

precedencegroup BidirectionalBindPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator <--==-->: BidirectionalBindPrecedence

public func <--==--><ValueType>(left: ControlProperty<ValueType>, right: EntityInOut<ValueType>) -> Disposable {
    let disposeToRight = left.bind(to: right)
    let disposeToLeft = right.bind(to: left)
    return CombinedDisposables(withDisposes: [disposeToRight, disposeToLeft])
}

fileprivate struct CombinedDisposables: Disposable {
    
    private var _disposeList: [Disposable] = []
    
    init(withDisposes list: [Disposable]) {
        _disposeList = list
    }
    
    func dispose() {
        _disposeList.forEach { (item) in
            item.dispose()
        }
    }
}
