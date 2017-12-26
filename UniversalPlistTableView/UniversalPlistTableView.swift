//
//  UniversalPlistTableView.swift
//  UniversalPlistTableView-Resources
//
//  Created by luhao on 10/11/2017.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

public let CONST_titleInputCellIdentifier = "titleInputCellIdentifier"
public let CONST_titleInputFreeHeightIdentifier = "titleInputFreeHeightIdentifier"

public var VAR_DebugPrint: Bool = true
internal func debugPrint(_ message: String) {
    if VAR_DebugPrint {
        print(message)
    }
}

public class UniversalPlistTableView: UIView {

    // MARK: - Public Property
    
    // MARK: - UI Config
    @IBInspectable public var style: UITableViewStyle = UITableViewStyle.grouped {
        didSet {
            tableViewModel.tableViewStyle = style
            reinitTableView()
        }
    }
    
    // MARK: - Signal
    /// In
    /// TableView will begin or end loading
    public var isLoading: PublishSubject<Bool> = PublishSubject()
    
    /// Out
    /// Before return cell, the last time to config cell model(RowEntity)
    /// 在 return cell 之前, 最后一次机会去配置 cell
    //public var configRowModel: PublishSubject<RowEntity> { get{ return tableViewModel.configRowModel } }
    
    /// TableView toast message when something wrong or some infomation needed user to know, Example the Row-input verification refered.
    /// 当有提示需要展视的时候, 会触发此信号, 按需订阅
    //public let toastAtIndexPath: PublishSubject<IndexPath> = PublishSubject()
    
    /// Did selected indexpath
    /// 选中某个 cell
    public var selectIndexPath: PublishSubject<RowEntity> {
        return tableViewModel.didSelectCell
    }
    
    /// Input text changed signal
    /// 任意一个 inputText 值改变的时候, 会触发此信号
    public var valueChanged: PublishSubject<RowEntity> = PublishSubject()
    
    /// Input text changed signal exclude vefified failed.
    /// inputText 值改变, 并且通过了验证器以后, 会触发此信号
    public var valueChangedFilted: PublishSubject<RowEntity> = PublishSubject()
    
    public var tableView: UITableView {
        return tableViewModel.tableView
    }
    public var sectionList: [SectionEntity] {
        return tableViewModel.sectionList
    }
    
    private var dataCenter: TableViewDataCenter {
        return tableViewModel.dataCenter
    }

    // MARK: - Private Property
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate let tableViewModel: TableViewModel = TableViewModel()
    fileprivate var plistHelper: PlistHelper!
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

// MARK: - Public Method
public extension UniversalPlistTableView {
    
    /// Fetch commint dictionary informattion
    /// 提交 TableView 中的信息
    public func extractCommitInfomation() -> [String : Any] {
        var result: [String : Any] = [:]
        sectionList.flatMap { $0.rows }.forEach { (row) in
            result[row.commitKey] = row.inputText
        }
        return result
    }
    
    /// 提交 tableView 中的信息, 并触发必填验证
    public func commitInputText() -> (Bool, [String : Any]) {
        return commit(property: .inputText)
    }
    
    /// 提交 tableView 中制定的信息, 并触发必填验证
    public func commit(property proName: RowEntityProperty) -> (Bool, [String : Any]) {
        
        /// 把每个 Cell 里的值拿出来
        var info: [String : Any] = [:]
        sectionList.flatMap { $0.rows }.forEach { (row) in
            info[row.commitKey] = row.value(forKey: proName.rawValue)
        }
        
        /// 每个 cell 触发一次验证
        var passedVerified: Bool = true
        VerifyCell: for rowItem in sectionList.flatMap({ $0.rows }) {
            if !rowItem.verifyCheck() {
                passedVerified = false
                break VerifyCell
            }
        }
        
        return (passedVerified, info)
    }
    
    /// Setup SourceData from plist
    /// 从 plist 设置数据源
    public func install(plist plistName: String, inBundle bundle: Bundle?) throws {
        plistHelper = try PlistHelper(plist: plistName, inBundle: bundle)
        tableViewModel.dataCenter.sectionList = plistHelper.getSectionList()
        
        sectionList.valueChanged.bind(to: valueChanged).disposed(by: disposeBag)
        sectionList.valueChangedVerifyPassed(inVerificaitons: dataCenter.verifiers).bind(to: valueChangedFilted).disposed(by: disposeBag)
    }
    
    /// Regist Cell
    /// 注册新的 cell
    public func regist<CellType: BasePlistCell>(cellClass aCell: CellType.Type, forIdentifier identifier: String) {
        registCustomModelTyle(aCell, withIdentifier: identifier)
        tableView.register(aCell, forCellReuseIdentifier: identifier)
    }
    
    public func regist(_ nib: UINib?, forIdentifier identifier: String) {
        guard let nibInstance: BasePlistCell = nib?.instantiate(withOwner: nil, options: nil).first as? BasePlistCell else {
            fatalError("注册的 Cell 必须要继承于 BasePlistCell")
        }
        registCustomModelTyle(type(of: nibInstance), withIdentifier: identifier)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Regist verification
    /// 注册验证逻辑
    public func regist<VerifierType>(verificationClass aVerification: VerifierType, forSegue segue: String) where VerifierType: ValidatorType {
        tableViewModel.regist(verificationClass: aVerification, forSegue: segue)
    }
    
    /// Assign dictionary to tableview
    /// 根据 key 给 cell 赋值
    @discardableResult
    public func fillingRow(property: RowEntityProperty, with dic: [String : Any]) -> PlistTableViewTruck<[String : Any]> {
        dic.forEach { (key, value) in
            if self.hasEntity(forKey: key) {
                if let valueStr = value as? String {
                    self.key(key).setValue(valueStr, forKey: property.rawValue)
                } else {
                    self.key(key).setValue("\(value)", forKey: property.rawValue)
                }
            }
        }
        
        return PlistTableViewTruck(plistTableView: self, object: dic)
    }
    
    /// Reload cell
    /// Reload 某个 key 的 cell
    public func reloadCell(_ indexKey: String, with animation: UITableViewRowAnimation = .fade) {
        let rowIndex = key(indexKey).indexPath
        if rowIndex.section != -1 {
            tableView.reloadRows(at: [rowIndex], with: animation)
        }
    }
    
    /// Reload 某些 key 的 cell
    public func reloadCell(_ indexKey: [Any], with animation: UITableViewRowAnimation = .fade) {
        var indexPathList: [IndexPath] = []
        indexKey.forEach { (item) in
            let rowIndex = self.key("\(item)").indexPath
            if rowIndex.section != -1 {
                indexPathList.append(rowIndex)
            }
        }
        tableView.reloadRows(at: indexPathList, with: animation)
    }
    
    /// Reload cell, 该 cell 的 key 对应入参 Dic 中的 Key
    public func reloadCell(_ indexKey: [String : Any], with animation: UITableViewRowAnimation = .fade) {
        var indexPathList: [IndexPath] = []
        indexKey.enumerated()
            .map {
                $0.element.key
            }
            .forEach { (item) in
                let rowIndex = self.key("\(item)").indexPath
                if rowIndex.section != -1 {
                    indexPathList.append(rowIndex)
                }
            }
        tableView.reloadRows(at: indexPathList, with: animation)
    }
    
    /// 设置某个 Section 是否可编辑
    public func section(_ sectionIndex: Int, isEditable isEdit: Bool) {
        guard sectionIndex < dataCenter.sectionList.count else {
            debugPrint("找不到下标为 \(sectionIndex) 的 Section, 可能越界")
            return
        }
        dataCenter.sectionList[sectionIndex].rows.forEach { (row) in
            row.isEditable = isEdit
        }
    }
    
    /// 设置某个 Section 是否可点击
    public func section(_ sectionIndex: Int, isClicked isClick: Bool) {
        guard sectionIndex < dataCenter.sectionList.count else {
            debugPrint("找不到下标为 \(sectionIndex) 的 Section, 可能越界")
            return
        }
        dataCenter.sectionList[sectionIndex].rows.forEach { (row) in
            row.isClicked = isClick
        }
    }
}

// MARK: - Private Method
extension UniversalPlistTableView {
    
    private func privateInit() {
        reinitTableView()
    }
    
    /// 重新初始化 tableView
    private func reinitTableView() {
        addSubview(tableViewModel.tableView)
        tableViewModel.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 注册自定义的数据类型
    private func registCustomModelTyle(_ cellType: BasePlistCell.Type, withIdentifier identifier: String) {
        let customType = cellType.customModelType()
        dataCenter.customModelTypes[identifier] = customType
    }
}

// MARK: - FindRowEntityAbility 能找到相应的 Cell entity
extension UniversalPlistTableView: FindRowEntityAbility {
    public func getDataCenter() -> TableViewDataCenter { return dataCenter }
}
