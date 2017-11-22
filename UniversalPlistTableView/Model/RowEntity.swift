//
//  RowEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit
import RxSwift

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
    @objc dynamic public var title: String = ""
    @objc public var titleFont: UIFont?
    @objc public var titleColor: UIColor?
    public var rawSubTitle: String = "" {
        didSet {
            subTitle = rawSubTitle.univDerive.content
            subTitleFont = rawSubTitle.univDerive.font
            subTitleColor = rawSubTitle.univDerive.color
        }
    }
    @objc dynamic public var subTitle: String = ""
    @objc public var subTitleFont: UIFont?
    @objc public var subTitleColor: UIColor?
    public var rawDescription: String = "" {
        didSet {
            desc = rawDescription.univDerive.content
            descFont = rawDescription.univDerive.font
            descColor = rawDescription.univDerive.color
        }
    }
    @objc dynamic public var desc: String = ""
    @objc public var descFont: UIFont?
    @objc public var descColor: UIColor?
    public var rawInputText: String = "" {
        didSet {
            inputText = rawInputText.univDerive.content
            inputTextFont = rawInputText.univDerive.font
            inputTextColor = rawInputText.univDerive.color
        }
    }
    @objc dynamic public var inputText: String = ""
    @objc public var inputTextFont: UIFont?
    @objc public var inputTextColor: UIColor?
    @objc public var inputPlaceHolder: String = ""
    @objc public var inputVerificationRegex: String = ""
    @objc public var inputVerificationMaxCount: Int = -1
    @objc public var inputVerificationDeferedMessage: String = ""
    @objc dynamic public var commitKey: String = ""
    @objc public var leadingIcon: String = ""
    @objc public var trailingIcon: String = ""
    @objc public var didSelectSegue: String = ""
    @objc public var verificationSegue: String = ""
    
    @objc dynamic public var date: Date?
    public var indexPath: IndexPath = IndexPath(row: -1, section: -1)
    
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
    
    override public init() {
        super.init()
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

// MARK: - Private method
extension RowEntity {
    
}

// MARK: - Public method
extension RowEntity {
    
}

extension Dictionary where Key == String, Value == Any {
    mutating func fetchValueAndRemove<ValueType>(withKey key: String) -> ValueType? {
        if let tmpValue = self[key] as? ValueType {
            self.removeValue(forKey: key)
            return tmpValue
        }
        return nil
    }
}
