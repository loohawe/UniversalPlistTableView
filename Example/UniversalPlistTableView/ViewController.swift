//
//  ViewController.swift
//  UniversalPlistTableView
//
//  Created by loohawe@gmail.com on 11/09/2017.
//  Copyright (c) 2017 loohawe@gmail.com. All rights reserved.
//

import UIKit
import RxSwift
import UniversalPlistTableView

class ViewController: UIViewController {
    
    var uniTableView: UniversalPlistTableView!
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uniTableView = UniversalPlistTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 620))
        
        /// 配置 Cell
        uniTableView.configRowModel.subscribe(onNext: { (rowEntity) in
            rowEntity.title = "luhao"
        }).disposed(by: disposeBag)
        
        /// 订阅错误消息
        /// 可以获取相应的 section 或 row
        uniTableView.toastAtIndexPath.map(uniTableView.pickUpRow).subscribe(onNext: { (sec) in
        }).disposed(by: disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func commitInfoAction(_ sender: UIButton) {
        print(uniTableView.extractCommitInfomation())
    }
}

