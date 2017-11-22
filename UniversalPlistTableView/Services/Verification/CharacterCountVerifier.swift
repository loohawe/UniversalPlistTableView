//
//  CharacterCountVerifier.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxSwift
import RxCocoa

public struct CharacterCountVerifier: ValidatorType {
    
    public func verify(cellModel model: RowEntity) -> VerificationResult {
        if model.inputVerificationMaxCount < 0 {
            return .passed
        }
        
        if model.inputText.count > model.inputVerificationMaxCount {
            return .failed
        }
        
        return .passed
    }
    
}
