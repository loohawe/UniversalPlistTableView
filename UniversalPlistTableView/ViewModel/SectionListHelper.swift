//
//  SectionListHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 22/11/2017.
//

import UIKit
import RxSwift

extension Array where Element == SectionEntity {
    
    var valueChanged: Observable<IndexPath> {
        let observableList: [Observable<IndexPath>] = []
        self.forEach { (secItem) in
            secItem.rows.forEach({ (rowItem) in
                
            })
        }
        self.forEach { (secItem) in
            secItem.rows.forEach({ (rowItem) in
                rowItem.rx.inputText.subscribe(onNext: { (inputStr) in
                    print("****************\(inputStr)")
                }).disposed(by: disposeBag)
            })
        }
        return Observable.merge(observableList)
    }
}
