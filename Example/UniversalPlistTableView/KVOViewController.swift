//
//  KVOViewController.swift
//  UniversalPlistTableView_Example
//
//  Created by luhao on 21/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import UniversalPlistTableView

var count: Int = 0

@objc class Person: NSObject {
    @objc dynamic var name: String = "a"
    var block: (() -> ()) = {}
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

class KVOViewController: UIViewController {
    
    var row: RowEntity = RowEntity()
    //var me: Person = Person()
    @IBOutlet weak var inputSomthing: UITextField!
    let disposeBag: DisposeBag = DisposeBag()
    
    var meName: Observable<String?>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputSub = row.rx.inputText
        inputSub.subscribe(onNext: { (str) in
            print("---------\(str)")
        }).disposed(by: disposeBag)
        
        (inputSomthing.rx.text).bind(to: inputSub).disposed(by: disposeBag)
        inputSub.bind(to: inputSomthing.rx.text).disposed(by: disposeBag)
        
//        meName = me.rx.observe(String.self, "name")
//        meName.subscribe(onNext: { (str) in
//            print("############\(str!)")
//        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func heiHeiHeiAction(_ sender: UIButton) {
        row.inputText = "\(count)"
        row.setValue("\(count)", forKey: "inputText")
        //row.setValue("\(count)", forKey: "inputText")
        //me.name = "\(count)"
        //me.setValue("\(count)", forKey: "name")
        count += 1
    }
    @IBAction func showHeiHeiHeiAction(_ sender: UIButton) {
        print("++++++++++\(row.inputText)")
    }
    @IBAction func setModelAction(_ sender: UIButton) {
        row.inputText = "\(count)"
        count += 2
    }
}
