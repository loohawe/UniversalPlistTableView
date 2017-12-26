//
//  CustomEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 26/12/2017.
//

import Foundation

public protocol CustomEntityType {
    init()
}

public class BaseCustomEntity: CustomEntityType {
    required public init() { }
    final weak var rowEntity: RowEntity!
}
