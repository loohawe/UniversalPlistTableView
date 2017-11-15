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
            
        }
    }
    public var title: String = ""
    public var titleFont: UIFont?
    public var titleColor: UIColor?
    public var rawSubTitle: String = "" {
        didSet {
            
        }
    }
    public var subTitle: String = ""
    public var subTitleFont: UIFont?
    public var subTitleColor: UIColor?
    public var rawDescription: String = "" {
        didSet {
            
        }
    }
    public var desc: String = ""
    public var descFont: UIFont?
    public var descColor: UIColor?
    public var rawInputText: String = "" {
        didSet {
            
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
    public var verifier: ValidatorProtocol?
}
