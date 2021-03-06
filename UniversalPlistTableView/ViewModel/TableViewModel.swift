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
    /// Did select cell signal
    internal var didSelectCell: PublishSubject<RowEntity> = PublishSubject()
    
    /// 数据中心, 包括 section list 和 验证器
    internal var dataCenter: TableViewDataCenter = TableViewDataCenter(sectionList: [])
    internal var sectionList: [SectionEntity] {
        return dataCenter.sectionList
    }
    
    internal var tableViewStyle: UITableViewStyle = UITableViewStyle.grouped {
        didSet { reinitTableView() }
    }
    
    internal var tableView: UITableView!
    
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

extension TableViewModel: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowModel = pickupRow(indexPath)
        if rowModel.height < 0 {
            return UITableViewAutomaticDimension
        }
        if rowModel.isHidden {
            return 0.0
        }
        return CGFloat(rowModel.height)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowModel = pickupRow(indexPath)
        if rowModel.isClicked {
            didSelectCell.onNext(rowModel)
            didSelect(row: rowModel)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = sectionList[section]
        var sectionHeight: CGFloat = 0.1
        SectionLoop: for i in 0..<sec.rows.count {
            if !sec.rows[i].isHidden {
                sectionHeight = CGFloat(sec.headerHeight)
                break SectionLoop
            }
        }
        return sectionHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sec = sectionList[section]
        var sectionHeight: CGFloat = 0.1
        SectionLoop: for i in 0..<sec.rows.count {
            if !sec.rows[i].isHidden {
                sectionHeight = CGFloat(sec.footerHeight)
                break SectionLoop
            }
        }
        return sectionHeight
    }
    
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
            fatalError("🐼🐼🐼UniversalPlistTableViewCell must coform protocol: PlistCellProtocol\n🐼🐼🐼 Plist table view 注册的 Cell 必须继承自 BasePlistCell")
        }
        plistCell.bindCellModel(rowModel)
        if let unwrapCustom = rowModel.customEntity {
            plistCell.updateCell(rowModel, unwrapCustom)
        }
        cell.isHidden = rowModel.isHidden
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        let sec = sectionList[section]
        label.text = sec.headerTitle.isEmpty ? " " : sec.headerTitle
        label.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(15.0)
            make.centerY.equalToSuperview()
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sec = sectionList[section]
        return sec.headerTitle.isEmpty ? " " : sec.headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sec = sectionList[section]
        return sec.footerTitle.isEmpty ? " " : sec.footerTitle
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
        tableView.reloadData()
    }
}

// MARK: - Private Method
extension TableViewModel {
    
    fileprivate func privateInit() {
        /// 初始化 tableView
        reinitTableView()
        /// 注册预设的验证器
        registPresetVerifier()
        /// 注册预设的自定义数据类型
        registPresetCustomModel()
    }
    
    /// 重新初始化 tableView, 注意这个方法里 tableview 可能为空
    private func reinitTableView() {
        if tableView != nil {
            tableView.removeFromSuperview()
            tableView = nil
        }
        
        let newTableView: UITableView = UITableView(frame: CGRect.zero, style: tableViewStyle)
        registPresetCell(newTableView)
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.estimatedRowHeight = 44.0
        
        tableView = newTableView
        dataCenter.tableView = tableView
    }
    
    /// 注册预设的 Cell
    private func registPresetCell(_ aTableView: UITableView) {
        let cellNib = UINib(nibName: "TitleInputCell", bundle: BundleHelper.resourcesBundle())
        aTableView.register(cellNib, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        
        let freeHeightCell = UINib(nibName: "TitleInputFreeHeight", bundle: BundleHelper.resourcesBundle())
        aTableView.register(freeHeightCell, forCellReuseIdentifier: CONST_titleInputFreeHeightIdentifier)
        
        let titleDescImage = UINib(nibName: "TitleDescImageCell", bundle: BundleHelper.resourcesBundle())
        aTableView.register(titleDescImage, forCellReuseIdentifier: CONST_titleDescImageCellIdentifier)
        
        let checkTime = UINib(nibName: "CheckTimeCell", bundle: BundleHelper.resourcesBundle())
        aTableView.register(checkTime, forCellReuseIdentifier: CONST_checkTimeCellIdentifier)
        
        let discuss = UINib(nibName: "DiscussCell", bundle: BundleHelper.resourcesBundle())
        aTableView.register(discuss, forCellReuseIdentifier: CONST_discussCellIdentifier)
    }
    
    /// 注册预设的验证器
    private func registPresetVerifier() {
        //regist(verificationClass: CharacterCountVerifier(), forSegue: "characterCountVerify")
        regist(verificationClass: AgeGreaterVerifier(), forSegue: CONST_VERIFY_AgeGreaterVerifier)
    }
    
    /// 注册自定义的数据类型
    private func registPresetCustomModel() {
        let type1 = TitleInputCell.customModelType()
        dataCenter.customModelTypes[CONST_titleInputCellIdentifier] = type1
        
        let type2 = TitleInputFreeHeight.customModelType()
        dataCenter.customModelTypes[CONST_titleInputFreeHeightIdentifier] = type2
        
        let type3 = TitleDescImageCell.customModelType()
        dataCenter.customModelTypes[CONST_titleDescImageCellIdentifier] = type3
        
        let type4 = CheckTimeCell.customModelType()
        dataCenter.customModelTypes[CONST_checkTimeCellIdentifier] = type4
        
        let type5 = DiscussCell.customModelType()
        dataCenter.customModelTypes[CONST_discussCellIdentifier] = type5
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
                if self.tableView.cellForRow(at: rowItem.indexPath) != nil {
                    
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
