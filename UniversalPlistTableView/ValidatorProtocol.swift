//
//  UniversalValidatorProtocol.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit
import RxSwift

public enum VerificationResult {
    case passed
    case failed
}

public protocol ValidatorType {
    func verify(cellModel model: RowEntity) -> VerificationResult
}

extension ValidatorType {
    public func verify(cellModel model: RowEntity) -> VerificationResult {
        return .passed
    }
}

