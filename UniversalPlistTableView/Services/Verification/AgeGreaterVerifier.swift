//
//  AgeGreaterVerifier.swift
//  UniversalPlistTableView
//
//  Created by luhao on 27/12/2017.
//

import Foundation

public struct AgeGreaterVerifier: ValidatorType {
    
    public func verify(cellModel model: RowEntity) -> Bool {
        if Int(model.inputText) ?? 0 >= 20 {
            return true
        }
        return false
    }
    
}
