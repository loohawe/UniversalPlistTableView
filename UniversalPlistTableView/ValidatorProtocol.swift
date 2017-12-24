//
//  UniversalValidatorProtocol.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit
import RxSwift


public protocol ValidatorType {
    func verify(cellModel model: RowEntity) -> Bool
}

extension ValidatorType {
    public func verify(cellModel model: RowEntity) -> Bool {
        return true
    }
}

