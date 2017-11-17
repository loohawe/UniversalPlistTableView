//
//  SectionEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit

public class SectionEntity: NSObject {

    var rawHeaderTitle: String = "" {
        didSet {
            headerTitle = rawHeaderTitle.univDerive.content
            headerTitleFont = rawHeaderTitle.univDerive.font
            headerTitleColor = rawHeaderTitle.univDerive.color
        }
    }
    var headerTitle: String = ""
    var headerTitleFont: UIFont?
    var headerTitleColor: UIColor?
    var sectionHeight: Double = 0.0
    
    var rawFooterTitle: String = "" {
        didSet {
            footerTitle = rawFooterTitle.univDerive.content
            footerTitleFont = rawFooterTitle.univDerive.font
            footerTitleColor = rawFooterTitle.univDerive.color
        }
    }
    var footerTitle: String = ""
    var footerTitleFont: UIFont?
    var footerTitleColor: UIColor?
    var footerHeight: Double = 0.0
    
    var section: Int = -1
    var rows: [RowEntity] = []
    
    override public func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        var mutableDic = keyedValues
        
        if let rawTitle = mutableDic["headerTitle"] as? String {
            rawHeaderTitle = rawTitle
            mutableDic.removeValue(forKey: "headerTitle")
        }
        if let rawFooter = mutableDic["footerTitle"] as? String {
            rawFooterTitle = rawFooter
            mutableDic.removeValue(forKey: "footerTitle")
        }
        
        super.setValuesForKeys(mutableDic)
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
}
