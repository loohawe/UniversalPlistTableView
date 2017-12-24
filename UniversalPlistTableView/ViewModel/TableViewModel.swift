//
//  TableViewModel.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit
import RxSwift

internal class TableViewModel: NSObject {
    
    /// Out
    internal var cellToastAtIndexPath: PublishSubject<IndexPath> = PublishSubject()
    
    internal let configRowModel: PublishSubject<RowEntity> = PublishSubject()
    internal var dataCenter: TableViewDataCenter = TableViewDataCenter(sectionList: [])
    internal var sectionList: [SectionEntity] {
        return dataCenter.sectionList
    }
    
    internal var didSelectCell: PublishSubject<RowEntity> = PublishSubject()
    
    internal let tableView: UITableView = {
        let tempTable: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
        let cellNib = UINib(nibName: "TitleInputCell", bundle: BundleHelper.resourcesBundle())
        tempTable.register(cellNib, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        //tempTable.register(TitleInputCell.self, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        return tempTable
    }()
    
    /// MARK: - Private property
    var disposeBag: DisposeBag = DisposeBag()
    
    
    /// MARK: - Override
    override init() {
        super.init()
        privateInit()
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
        dataCenter.verifiers.removeAll()
    }
}

// MARK: - TableView Delegate
extension TableViewModel: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowModel = pickupRow(indexPath)
        return CGFloat(rowModel.height)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowMode = pickupRow(indexPath)
        didSelectCell.onNext(rowMode)
        didSelect(row: rowMode)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = sectionList[section]
        return CGFloat(sec.headerHeight)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = sectionList[section]
        return CGFloat(sec.footerHeight)
    }
    
}

extension TableViewModel: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = pickupRow(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier, for: indexPath)
        guard let plistCell = cell as? BasePlistCell else {
            fatalError("🐼🐼🐼UniversalPlistTableViewCell must coform protocol: PlistCellProtocol\n🐼🐼🐼我的超级牛逼无敌 Plist table view 注册的 Cell 必须实现协议 PlistCellProtocol, 不实现就不让你用哟, 我的哥")
        }
        plistCell.bindCellModel(rowModel)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = sectionList[section]
        return sec.headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sec = sectionList[section]
        return sec.footerTitle
    }
}

// MARK: - Public Method
extension TableViewModel {
    
    /// Regist verification
    /// 注册验证逻辑
    public func regist<VerifierType>(verificationClass aVerification: VerifierType, forSegue segue: String) where VerifierType: ValidatorType {
        dataCenter.verifiers[segue] = aVerification
    }
    
    /// Reload Data
    /// 刷新数据
    public func reloadData() {
        //disposeBag = DisposeBag()
        dataCenter.sectionList.flatMap { $0.rows }.forEach { $0.dataCenter = dataCenter }
        //oberverRowModel(inSections: sectionList)
        tableView.reloadData()
    }
}

// MARK: - Private Method
extension TableViewModel {
    
    fileprivate func privateInit() {
        tableView.delegate = self
        tableView.dataSource = self
        regist(verificationClass: CharacterCountVerifier(), forSegue: "characterCountVerify")
    }
    
    fileprivate func pickupRow(_ indexPath: IndexPath) -> RowEntity {
        sectionList[indexPath.section].section = indexPath.section
        sectionList[indexPath.section].rows[indexPath.row].indexPath = indexPath
        return sectionList[indexPath.section].rows[indexPath.row]
    }
    
    /**
    fileprivate func oberverRowModel(inSections sec: [SectionEntity]) {
        sec.forEach { (secItem) in
            secItem.rows.forEach({ (rowItem) in
                rowItem.rx.inputText.subscribe(onNext: { (inputStr) in
                    //debugPrint("****************\(String(describing: inputStr))")
                }).disposed(by: disposeBag)
            })
        }
    }**/
    
    /// 观察 Section 里的事件, 对相关事件做必要订阅
    fileprivate func observeSetionList(_ secList: [SectionEntity]) {
        if secList.isEmpty { return }
        
        /// 验证不通过, 通知 cell
        secList
            .valueChangedVerifyFailed(inVerificaitons: dataCenter.verifiers)
            .subscribe(onNext: { (rowItem) in
                if let cellItem = self.tableView.cellForRow(at: rowItem.indexPath) {
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Cell 的 didSelect 事件
    fileprivate func didSelect(row entity: RowEntity) {
        let identifierModel = HandleIdentifier<Any, Any>(type: CellEventType.click, keyPath: nil)
        entity.implementHandle(withIdentifier: identifierModel)
    }
}
