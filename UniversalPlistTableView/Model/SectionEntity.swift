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
    var headerHeight: Double = 0.0
    
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
        headerHeight = mutableDic.fetchValueAndRemove(withKey: "headerHeight") ?? 0.0
        if let intHeight: Int = mutableDic.fetchValueAndRemove(withKey: "sectionHeight") {
            headerHeight = Double(intHeight)
        }
        
        footerHeight = mutableDic.fetchValueAndRemove(withKey: "footerHeight") ?? 0.0
        if let intHeight: Int = mutableDic.fetchValueAndRemove(withKey: "footerHeight") {
            footerHeight = Double(intHeight)
        }
        
        if let rowsList: [[String : Any]] = mutableDic.fetchValueAndRemove(withKey: "rows") {
            var tmpRows: [RowEntity] = []
            rowsList.forEach({ (rowItem) in
                tmpRows.append(RowEntity(withDictionary: rowItem))
            })
            rows = tmpRows
        }
        
        super.setValuesForKeys(mutableDic)
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}
