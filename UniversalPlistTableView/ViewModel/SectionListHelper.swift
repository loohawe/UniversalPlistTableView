//
//  SectionListHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 22/11/2017.
//

import UIKit
import RxSwift

extension Array where Element == SectionEntity {
    
    var valueChanged: Observable<RowEntity> {
        var observableList: [Observable<RowEntity>] = []
        self.forEach { (secItem) in
            secItem.rows.forEach({ (rowItem: RowEntity) in
                let inputObs = rowItem.rx.inputText.map { [weak rowItem] _ -> RowEntity in
                    guard let `rowItem` = rowItem else {
                        fatalError()
                    }
                    return rowItem
                }.asObservable()
                observableList.append(inputObs)
                
                let dateObs = rowItem.rx.date.map { [weak rowItem] _ -> RowEntity in
                    guard let `rowItem` = rowItem else {
                        fatalError()
                    }
                    return rowItem
                }.asObservable()
                observableList.append(dateObs)
            })
        }
        return Observable.merge(observableList)
    }
    
    private func valueChanged(inVerificaitons ver: [String : ValidatorType], filted: @escaping (RowEntity) -> Bool) -> Observable<RowEntity> {
        return valueChanged.filter(filted).asObservable()
    }
    
    public func valueChangedVerifyPassed(inVerificaitons ver: [String : ValidatorType]) -> Observable<RowEntity> {
        return valueChanged(inVerificaitons: ver, filted: { (row) -> Bool in
            if let verify = ver[row.verificationSegue] {
                return verify.verify(cellModel: row) == .passed
            }
            return true
        })
    }
    
    public func valueChangedVerifyFailed(inVerificaitons ver: [String : ValidatorType]) -> Observable<RowEntity> {
        return valueChanged(inVerificaitons: ver, filted: { (row) -> Bool in
            if let verify = ver[row.verificationSegue] {
                return verify.verify(cellModel: row) == .failed
            }
            return true
        })
    }
}
