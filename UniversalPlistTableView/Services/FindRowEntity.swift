//
//  FindRowEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

/// Find the special row
/// 找到特定的一行
public protocol FindRowEntityAbility {

    /// All data
    /// 所有的数据
    func getDataCenter() -> TableViewDataCenter
    
    /// 根据 Commit Key 找 Row
    func key(_ commitKey: String) -> RowEntity
    
    /// 根据 IndexPath 找 Row
    func indexPath(_ indexPath: IndexPath) -> RowEntity
}

extension FindRowEntityAbility {
    
    public func hasEntity(forKey key: String) -> Bool {
        for item in getDataCenter().sectionList.flatMap({ $0.rows }) {
            if item.commitKey == key {
                return true
            }
        }
        return false
    }
    
    /// 根据 Commit Key 找 Row
    public func key(_ commitKey: String) -> RowEntity {
        for item in getDataCenter().sectionList.flatMap({ $0.rows }) {
            if item.commitKey == commitKey {
                return item
            }
        }
        print("\n\n\n================================\n没有找到 Key 为 \(commitKey) 的 Cell\n\n\n")
        return RowEntity.getEmptyEntity()
    }
    
    /// 根据 IndexPath 找 Row
    public func indexPath(_ indexPath: IndexPath) -> RowEntity {
        
        guard indexPath.section < getDataCenter().sectionList.count else {
            fatalError("\n\n\n================================\nIndexPath(Secion: \(indexPath.section), Row: \(indexPath.row)) 超出边界\n\n\n")
        }
        
        guard indexPath.row < getDataCenter().sectionList[indexPath.section].rows.count else {
            fatalError("\n\n\n================================\nIndexPath(Secion: \(indexPath.section), Row: \(indexPath.row)) 超出边界\n\n\n")
        }
        
        return getDataCenter().sectionList[indexPath.section].rows[indexPath.row]
    }
}
