//
//  IndexPathDerived.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit

extension UniversalPlistTableView {
    
    public func pickUpSection(on indexPath: IndexPath) -> SectionEntity {
        return SectionEntity()
    }
    
    public func pickUpRow(on indexPath: IndexPath) -> RowEntity {
        return RowEntity()
    }
}
