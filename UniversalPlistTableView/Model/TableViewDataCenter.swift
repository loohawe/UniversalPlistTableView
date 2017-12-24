//
//  SectionListWrap.swift
//  UniversalPlistTableView
//
//  Created by luhao on 21/12/2017.
//

import UIKit

/// Table view data source
public class TableViewDataCenter: NSObject {
    
    /// Sections
    var sectionList: [SectionEntity] = []
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
