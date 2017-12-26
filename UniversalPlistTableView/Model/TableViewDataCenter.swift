//
//  SectionListWrap.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

/// Table view data source
public class TableViewDataCenter: NSObject {
    
    /// 所属的 tableView
    weak var tableView: UITableView!
    
    /// Sections
    var sectionList: [SectionEntity] = [] {
        didSet {
            for section in 0..<sectionList.count {
                let secItem = sectionList[section]
                secItem.dataCenter = self
                for row in 0..<secItem.rows.count {
                    let rowItem = secItem.rows[row]
                    rowItem.dataCenter = self
                    rowItem.indexPath = IndexPath(row: row, section: section)
                }
            }
            tableView.reloadData()
        }
    }
    /// 这里都是过滤器
    var verifiers: [String : ValidatorType] = [:]
    
    init(sectionList list: [SectionEntity]) {
        super.init()
        sectionList = list
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

extension TableViewDataCenter: FindRowEntityAbility {
    public func getDataCenter() -> TableViewDataCenter { return self }
}
