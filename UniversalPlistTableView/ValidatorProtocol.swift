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
    case failed(String)
}

public protocol ValidatorProtocol {
    
    /// In
    var needVerify: PublishSubject<RowEntity> { get set }
    
    /// Out
    var verificationResult: Variable<VerificationResult> { get set }
    var disposeBag: DisposeBag { get set }
    
    /// Function
    init(withRowModel rowModel: RowEntity)
}

extension ValidatorProtocol {
    
}
