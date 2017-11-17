//
//  RowEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit

public class RowEntity: NSObject {
    
    public var identifier: String = ""
    public var accessoryType: UITableViewCellAccessoryType = .none
    public var height: Double = 44.0
    public var rawTitle: String = "" {
        didSet {
            title = rawTitle.univDerive.content
            titleFont = rawTitle.univDerive.font
            titleColor = rawTitle.univDerive.color
        }
    }
    public var title: String = ""
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var rawSubTitle: String = "" {
        didSet {
            subTitle = rawSubTitle.univDerive.content
            subTitleFont = rawSubTitle.univDerive.font
            subTitleColor = rawSubTitle.univDerive.color
        }
    }
    public var subTitle: String = ""
    public var subTitleFont: UIFont?
    public var subTitleColor: UIColor?
    public var rawDescription: String = "" {
        didSet {
            desc = rawDescription.univDerive.content
            descFont = rawDescription.univDerive.font
            descColor = rawDescription.univDerive.color
        }
    }
    public var desc: String = ""
    public var descFont: UIFont?
    public var descColor: UIColor?
    public var rawInputText: String = "" {
        didSet {
            inputText = rawInputText.univDerive.content
            inputTextFont = rawInputText.univDerive.font
            inputTextColor = rawInputText.univDerive.color
        }
    }
    public var inputText: String = ""
    public var inputTextFont: UIFont?
    public var inputTextColor: UIColor?
    public var inputPlaceHolder: String = ""
    public var inputVerificationRegex: String = ""
    public var inputVerificationMaxCount: Int = -1
    public var inputVerificationDeferedMessage: String = ""
    public var commitKey: String = ""
    public var leadingIcon: String = ""
    public var trailingIcon: String = ""
    public var didSelectSegue: String = ""
    public var verificationSegue: String = ""
    
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
        
        super.setValuesForKeys(mutableDic)
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
}

/// MARK: - Private method
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
