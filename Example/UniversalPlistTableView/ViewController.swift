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
import SnapKit
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UniversalPlistTableView!
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! tableView.install(plist: "PlistConfingGuid", inBundle: nil)
        //tableView.style = .plain
        
        let dateCellModel = tableView.key("date")
        dateCellModel.clickHandle { (row) in
            debugPrint("选择时间啦")
            self.tableView.key("comment").isHidden = true
            self.tableView.key("comment").reload()
        }
        dateCellModel.rx.subTitle.bind(to: dateCellModel.rx.inputText).disposed(by: disposeBag)
        
        let nameCellModel = tableView.key("name")
        nameCellModel.verifyFailedHandle(\RowEntity.inputText) { (previousCurrentValue, nowValue, row) in
            debugPrint("Name Cell 验证失败:\n\(previousCurrentValue)\n\(nowValue)\n\(row)\n------------------")
        }
        nameCellModel.endEdit.subscribe(onNext: { (row) in
            debugPrint("aaaa")
        }).disposed(by: disposeBag)
        
        let phoneCellModel = tableView.key("phone")
        phoneCellModel.verifyFailedHandle(\RowEntity.inputText) { (previousCurrentValue, nowValue, row) in
            debugPrint("Phone Cell 验证失败:\n\(previousCurrentValue)\n\(nowValue)\n\(row)\n------------------")
        }
        phoneCellModel.rx.subTitle.bind(to: phoneCellModel.rx.inputText).disposed(by: disposeBag)
        
        tableView.key("comment").customEvent(\CommitCellModel.commitAction) { [weak tableView] (newValue: Any?, rowItem: RowEntity) in
            print("\(String(describing: tableView?.commitInputText()))")
        }
        
        /**
        tableView
            .indexPath(IndexPath.init(row: 0, section: 0))
            .clickHandle { [unowned self] (rowEntity) in
                debugPrint("\(rowEntity.title)")
                self.tableView.indexPath(IndexPath.init(row: 1, section: 0)).title = "沃的天"
            }
            .verifyFailedHandle(\RowEntity.inputText) { (previousCurrentValue, nowValue, row) in
                debugPrint("第一个 Cell 验证失败:\n\(previousCurrentValue)\n\(nowValue)\n\(row)\n------------------")
        }
        
        tableView.key("age").clickHandle { [unowned self] (row) in
            self.tableView.key("name").inputText = "abcdef"
            self.tableView.key("favo").updateCustomModel(handle: { (item: TitleInputFace) in
                item.backgroundColor = UIColor.red
            })
            }.verifyFailedHandle(\RowEntity.inputText) { (previousCurrentValue, nowValue, row) in
                debugPrint("Age Cell 验证失败:\n\(previousCurrentValue)\n\(nowValue)\n\(row)\n------------------")
        }
        
        tableView.key("favo").customEvent(\TitleInputFace.fireAction) { (newValue: Any?, rowItem: RowEntity) in
            print("\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\(newValue)\n\(rowItem)")
        }**/
        
        /**
        /// 配置 Cell
        uniTableView.configRowModel.subscribe(onNext: { (rowEntity) in
            rowEntity.title = "luhao"
        }).disposed(by: disposeBag)
        
        /// 订阅错误消息
        /// 可以获取相应的 section 或 row
        uniTableView.toastAtIndexPath.map(uniTableView.pickUpRow).subscribe(onNext: { (sec) in
            
        }).disposed(by: disposeBag)
        
        uniTableView.toastAtIndexPath.subscribe(onNext: { (indexPath) in
            print(indexPath)
        }).disposed(by: disposeBag)
        
        uniTableView.valueChanged.subscribe(onNext: { (rowItem) in
            print("all============\(rowItem)")
        }).disposed(by: disposeBag)
        
        uniTableView.valueChangedFilted.subscribe(onNext: { (rowItem) in
            print("success================\(rowItem)")
        }).disposed(by: disposeBag) **/
        
        
    }

    @IBAction func commitInfoAction(_ sender: UIButton) {
        //debugPrint(tableView.extractCommitInfomation())
        debugPrint(tableView.commitInputText())
        
//        tableView.fillingRow(property: .title, with: [
//            "name": "大名",
//            "age": "贵庚",
//            "favo": "村上春树",
//            "nothing": 0.001
//            ])
        
//        tableView.fillingRow(property: .desc, with: [
//            "favo": "当我在跑步的时候我在想什么",
//            "nothing": 0.001
//            ]).reload()
        
//        tableView.section(0, isClicked: false)
//        tableView.section(0, isEditable: false)
//        tableView.key("age").isEditable = false
//        tableView.key("name").isClicked = false
    }
}

