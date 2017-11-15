//
//  CharacterCountVerifier.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxSwift
import RxCocoa

public class CharacterCountVerifier: ValidatorProtocol {
    
    /// In
    public var needVerify: PublishSubject<RowEntity> = PublishSubject()
    
    /// Out
    public var verificationResult: Variable<VerificationResult> = Variable(.passed)
    public var disposeBag: DisposeBag = DisposeBag()
    
    var count: Int
    
    required public init(withRowModel rowModel: RowEntity) {
        count = rowModel.inputVerificationMaxCount
        needVerify.map(verify).bind(to: verificationResult).disposed(by: disposeBag)
    }
}

// MARK: - Private method
extension CharacterCountVerifier {
    
    fileprivate func verify(_ model: RowEntity) -> VerificationResult {
        if count < 0 {
            return .passed
        }
        
        if model.inputText.count > count {
            return .failed(model.inputVerificationDeferedMessage)
        } else {
            return .passed
        }
    }
}
