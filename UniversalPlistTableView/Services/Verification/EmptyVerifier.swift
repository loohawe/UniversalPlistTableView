//
//  EmptyVerifier.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxCocoa
import RxSwift

public class EmptyVerifier: ValidatorProtocol {

    /// In
    public var needVerify: PublishSubject<RowEntity> = PublishSubject()
    
    /// Out
    public var verificationResult: Variable<VerificationResult> = Variable(.passed)
    public var disposeBag: DisposeBag = DisposeBag()
    
    required public init(withRowModel rowModel: RowEntity) {
        needVerify
            .map({_ in return VerificationResult.passed })
            .bind(to: verificationResult)
            .disposed(by: disposeBag)
    }
}
