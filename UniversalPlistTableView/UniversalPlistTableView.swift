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

public var VAR_DebugPrint: Bool = true
internal func debugPrint(_ message: String) {
    if VAR_DebugPrint {
        print(message)
    }
}

public class UniversalPlistTableView: UIView {

    // MARK: - Public Property
    /// In
    /// TableView will begin or end loading
    public var isLoading: PublishSubject<Bool> = PublishSubject()
    
    /// Out
    /// Before return cell, the last time to config cell model(RowEntity)
    /// 在 return cell 之前, 最后一次机会去配置 cell
    public var configRowModel: PublishSubject<RowEntity> { get{ return tableViewModel.configRowModel } }
    
    /// TableView toast message when something wrong or some infomation needed user to know, Example the Row-input verification refered.
    /// 当有提示需要展视的时候, 会触发此信号, 按需订阅
    public let toastAtIndexPath: PublishSubject<IndexPath> = PublishSubject()
    
    /// Did selected indexpath
    /// 选中某个 cell
    public var selectIndexPath: PublishSubject<RowEntity> {
        return tableViewModel.didSelectCell
    }
    
    public var valueChanged: PublishSubject<RowEntity> = PublishSubject()
    public var valueChangedFilted: PublishSubject<RowEntity> = PublishSubject()
    
    public var tableView: UITableView {
        return tableViewModel.tableView
    }
    public var sectionList: [SectionEntity] {
        return tableViewModel.sectionList
    }
    public var dataCenter: TableViewDataCenter {
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
    
    /// Setup SourceData from plist
    /// 从 plist 设置数据源
    public func install(plist plistName: String, inBundle bundle: Bundle?) throws {
        plistHelper = try PlistHelper(plist: plistName, inBundle: bundle)
        tableViewModel.dataCenter.sectionList = plistHelper.getSectionList()
        tableViewModel.reloadData()
        
        sectionList.valueChanged.bind(to: valueChanged).disposed(by: disposeBag)
        sectionList.valueChangedVerifyPassed(inVerificaitons: dataCenter.verifiers).bind(to: valueChangedFilted).disposed(by: disposeBag)
    }
    
    /// Regist Cell
    /// 注册新的 cell
    public func regist<CellType>(cellClass aCell: CellType.Type, forIdentifier identifier: String) where CellType: UITableViewCell, CellType: PlistCellProtocol {
        tableView.register(aCell, forCellReuseIdentifier: identifier)
    }
    
    public func regist(_ nib: UINib?, forIdentifier identifier: String) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Regist verification
    /// 注册验证逻辑
    public func regist<VerifierType>(verificationClass aVerification: VerifierType, forSegue segue: String) where VerifierType: ValidatorType {
        tableViewModel.regist(verificationClass: aVerification, forSegue: segue)
    }
}

// MARK: - Private Method
extension UniversalPlistTableView {
    
    fileprivate func privateInit() {
        tableViewModel.cellToastAtIndexPath.bind(to: toastAtIndexPath).disposed(by: disposeBag)
        addSubview(tableViewModel.tableView)
        tableViewModel.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - FindRowEntityAbility 能找到相应的 Cell entity
extension UniversalPlistTableView: FindRowEntityAbility {
    public func getDataCenter() -> TableViewDataCenter { return dataCenter }
}
