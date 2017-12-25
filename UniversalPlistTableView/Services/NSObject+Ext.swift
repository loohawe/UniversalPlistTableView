//
//  NSObject+Ext.swift
//  UniversalPlistTableView
//
//  Created by luhao on 25/12/2017.
//

import UIKit

extension NSObject {
    
    /// 判断该 Object 是否包含某个属性
    public func hasKey(_ key: String) -> Bool {
        
        let selfMirror = Mirror(reflecting: self)
        var selfPropertyNameList: [String] = []
        for child in selfMirror.children {
            //debugPrint("属性名:\(child.label!)，值:\(child.value)")
            selfPropertyNameList.append("\(child.label!)")
        }
        
        return selfPropertyNameList.contains(key)
    }
    
}
