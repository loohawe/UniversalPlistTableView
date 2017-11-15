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
            
        }
    }
    var headerTitle: String = ""
    var headerTitleFont: UIFont?
    var headerTitleColor: UIColor?
    var sectionHeight: Double = 0.0
    
    var rawFooterTitle: String = "" {
        didSet {
            
        }
    }
    var footerTitle: String = ""
    var footerTitleFont: UIFont?
    var footerTitleColor: UIColor?
    var footerHeight: Double = 0.0
    
    var section: Int = -1
    var rows: [RowEntity] = []
}
