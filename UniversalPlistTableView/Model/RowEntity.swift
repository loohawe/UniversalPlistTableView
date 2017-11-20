//
//  RowEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit
import RxSwift
import RxCocoa

public class RowEntity: NSObject {
    
    @objc public var identifier: String = ""
    public var accessoryType: UITableViewCellAccessoryType = .none
    public var height: Double = 44.0
    public var rawTitle: String = "" {
        didSet {
            title = rawTitle.univDerive.content
            titleFont = rawTitle.univDerive.font
            titleColor = rawTitle.univDerive.color
        }
    }
    @objc public var title: String = ""
    @objc public var titleFont: UIFont?
    @objc public var titleColor: UIColor?
    public var rawSubTitle: String = "" {
        didSet {
            subTitle = rawSubTitle.univDerive.content
            subTitleFont = rawSubTitle.univDerive.font
            subTitleColor = rawSubTitle.univDerive.color
        }
    }
    @objc public var subTitle: String = ""
    @objc public var subTitleFont: UIFont?
    @objc public var subTitleColor: UIColor?
    public var rawDescription: String = "" {
        didSet {
            desc = rawDescription.univDerive.content
            descFont = rawDescription.univDerive.font
            descColor = rawDescription.univDerive.color
        }
    }
    @objc public var desc: String = ""
    @objc public var descFont: UIFont?
    @objc public var descColor: UIColor?
    public var rawInputText: String = "" {
        didSet {
            inputText = rawInputText.univDerive.content
            inputTextFont = rawInputText.univDerive.font
            inputTextColor = rawInputText.univDerive.color
        }
    }
    @objc public var inputText: String = ""
    @objc public var inputTextFont: UIFont?
    @objc public var inputTextColor: UIColor?
    @objc public var inputPlaceHolder: String = ""
    @objc public var inputVerificationRegex: String = ""
    @objc public var inputVerificationMaxCount: Int = -1
    @objc public var inputVerificationDeferedMessage: String = ""
    @objc public var commitKey: String = ""
    @objc public var leadingIcon: String = ""
    @objc public var trailingIcon: String = ""
    @objc public var didSelectSegue: String = ""
    @objc public var verificationSegue: String = ""
    
    public var date: Date?
    public var indexPath: IndexPath = IndexPath(row: -1, section: -1)
    public var verifier: ValidatorProtocol!
    
    override public func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        var mutableDic = keyedValues
        accessoryType = UITableViewCellAccessoryType(rawValue: mutableDic.fetchValueAndRemove(withKey: "accessoryType") ?? 0) ?? .none
        rawTitle = mutableDic.fetchValueAndRemove(withKey: "title") ?? ""
        rawSubTitle = mutableDic.fetchValueAndRemove(withKey: "subTitle") ?? ""
        rawDescription = mutableDic.fetchValueAndRemove(withKey: "description") ?? ""
        rawInputText = mutableDic.fetchValueAndRemove(withKey: "inputText") ?? ""
        
        if let tmpHeight: Double = mutableDic.fetchValueAndRemove(withKey: "height") {
            height = tmpHeight
        } else if let tmpHeight: Int = mutableDic.fetchValueAndRemove(withKey: "height") {
            height = Double(tmpHeight)
        }
        
        super.setValuesForKeys(mutableDic)
    }
    
    override init() {
        super.init()
        verifier = EmptyVerifier(withRowModel: self)
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
        
        if verificationSegue.isEmpty {
            verifier = EmptyVerifier(withRowModel: self)
        } else {
            guard let verifierTypes = TableViewModel.verifierTypes,
                let veType = verifierTypes[verificationSegue] else {
                    fatalError("🐱🐱🐱现在 verificationSegue 并没有注册, 需要调用 regist(verificationClass aVerification: VerifierType.Type, forSegue segue: String) 进行注册.")
            }
            if let verifierType = veType as? ValidatorProtocol.Type {
                verifier = verifierType.init(withRowModel: self)
            } else {
                verifier = EmptyVerifier(withRowModel: self)
            }
        }
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

/// MARK: - Private method
extension RowEntity {
    
    
}

//extension Reactive where Base: RowEntity {
//
//    public var inputText: EntityInOut<String?> {
//        return inputTextValue
//    }
//
//
//    public var inputTextValue: EntityInOut<String?> {
//        return EntityInOut()
//    }
//
//    public func entityInOut<T>(getter: @escaping (Base) -> T, setter: @escaping (Base, T) -> ()) {
//
//    }
//}
//
//public struct EntityInOut<PropertyType> : EntityInOutType {
//
//    public typealias E = PropertyType
//
//    public func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, PropertyType == O.E {
//
//    }
//
//    public func on(_ event: Event<PropertyType>) {
//
//    }
//}
//
//public protocol EntityInOutType : ObservableType, ObserverType {
//
//}

extension Dictionary where Key == String, Value == Any {
    mutating func fetchValueAndRemove<ValueType>(withKey key: String) -> ValueType? {
        if let tmpValue = self[key] as? ValueType {
            self.removeValue(forKey: key)
            return tmpValue
        }
        return nil
    }
}
