//
//  SectionEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit

public class SectionEntity: NSObject {

    public var rawHeaderTitle: String = "" {
        didSet {
            headerTitle = rawHeaderTitle.univDerive.content
            headerTitleFont = rawHeaderTitle.univDerive.font
            headerTitleColor = rawHeaderTitle.univDerive.color
        }
    }
    public var headerTitle: String = ""
    public var headerTitleFont: UIFont?
    public var headerTitleColor: UIColor?
    public var headerHeight: Double = 0.0
    
    public var rawFooterTitle: String = "" {
        didSet {
            footerTitle = rawFooterTitle.univDerive.content
            footerTitleFont = rawFooterTitle.univDerive.font
            footerTitleColor = rawFooterTitle.univDerive.color
        }
    }
    public var footerTitle: String = ""
    public var footerTitleFont: UIFont?
    public var footerTitleColor: UIColor?
    public var footerHeight: Double = 0.0
    
    public var section: Int = -1
    public var rows: [RowEntity] = []
    
    internal weak var dataCenter: TableViewDataCenter?
    
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
    
    /// Reload 该 section 对应的 Cells
    public func reload(_ animation: UITableViewRowAnimation = .fade) -> Void {
        if let dataCen = dataCenter {
            let indexPathList = rows.map { $0.indexPath }
            dataCen.tableView.reloadRows(at: indexPathList, with: animation)
        }
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}
