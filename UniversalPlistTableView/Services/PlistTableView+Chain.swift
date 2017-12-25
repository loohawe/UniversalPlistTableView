//
//  PlistTableView+Chain.swift
//  UniversalPlistTableView
//
//  Created by luhao on 25/12/2017.
//

import Foundation

/// PlistTableView 用来做链式调用
public struct PlistTableViewTruck<TakeType> {
    public weak var plistTableView: UniversalPlistTableView?
    public let object: TakeType
    
    public func reload() {
        if let tableView = plistTableView {
            if let strObj = object as? String {
                tableView.reloadCell(strObj)
            } else if let listObj = object as? [Any] {
                tableView.reloadCell(listObj)
            } else if let dicObj = object as? [String : Any] {
                tableView.reloadCell(dicObj)
            }
        }
    }
}
