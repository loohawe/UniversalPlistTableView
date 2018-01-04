//
//  RowEntity+Rx.swift
//  UniversalPlistTableView
//
//  Created by luhao on 22/11/2017.
//

import Foundation
import RxSwift

extension Reactive where Base: RowEntity {
    
    public var inputText: EntityInOut<String?> {
        return value(keyPath: "inputText", setter: { (value: String) in
            self.base.inputText = value
        })
    }
    
    public var title: EntityInOut<String?> {
        return value(keyPath: "title", setter: { (value: String) in
            self.base.title = value
        })
    }
    
    public var subTitle: EntityInOut<String?> {
        return value(keyPath: "subTitle", setter: { (value: String) in
            self.base.subTitle = value
        })
    }
    
    public var desc: EntityInOut<String?> {
        return value(keyPath: "desc", setter: { (value: String) in
            self.base.desc = value
        })
    }
    
    public var commitKey: EntityInOut<String?> {
        return value(keyPath: "commitKey", setter: { (value: String) in
            self.base.commitKey = value
        })
    }
    
    public var date: EntityInOut<Date?> {
        return value(keyPath: "date", setter: { (value: Date) in
            self.base.date = value
        })
    }
    
    public var leadingIcon: EntityInOut<String?> {
        return value(keyPath: "leadingIcon", setter: { (value: String) in
            self.base.leadingIcon = value
        })
    }
    
    public var trailingIcon: EntityInOut<String?> {
        return value(keyPath: "trailingIcon", setter: { (value: String) in
            self.base.trailingIcon = value
        })
    }
    
    public var isClicked: EntityInOut<Bool?> {
        return value(keyPath: "isClicked", setter: { (value: Bool) in
            self.base.isClicked = value
        })
    }
    
    public var isEditable: EntityInOut<Bool?> {
        return value(keyPath: "isEditable", setter: { (value: Bool) in
            self.base.isEditable = value
        })
    }
    
    public var isHidden: EntityInOut<Bool?> {
        return value(keyPath: "isHidden", setter: { (value: Bool) in
            self.base.isHidden = value
        })
    }
}

extension Reactive where Base: RowEntity {
    public func value<ValueType>(keyPath: String, setter: @escaping (ValueType) -> ()) -> EntityInOut<ValueType?> {
        let source: Observable<ValueType?> = base.rx.observeWeakly(ValueType.self, keyPath)
        let observer: AnyObserver = AnyObserver<ValueType?>.init { (event) in
            switch event {
            case .next(let realValue):
                if let hasValue = realValue {
                    setter(hasValue)
                }
            case .error(let error):
                #if DEBUG
                    fatalError("\(error)")
                #else
                    debugPrint("\(error)")
                #endif
            case .completed:
                ()
            }
        }
        return EntityInOut<ValueType?>(values: source, valueSink: observer)
    }
}

public struct EntityInOut<PropertyType> : EntityInOutType {
    
    public typealias E = PropertyType
    
    let _values: Observable<PropertyType>
    let _valueSink: AnyObserver<PropertyType>
    
    public init<V: ObservableType, S: ObserverType>(values: V, valueSink: S) where E == V.E, E == S.E {
        _values = values.subscribeOn(ConcurrentMainScheduler.instance)
        _valueSink = valueSink.asObserver()
    }
    
    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, O.E == PropertyType  {
        return _values.subscribe(observer)
    }
    
    public func on(_ event: Event<PropertyType>) {
        switch event {
        case .error(let error):
            #if DEBUG
                fatalError("\(error)")
            #else
                print("\(error)")
            #endif
        case .next:
            _valueSink.on(event)
        case .completed:
            _valueSink.on(event)
        }
    }
}

public protocol EntityInOutType : ObservableType, ObserverType { }
