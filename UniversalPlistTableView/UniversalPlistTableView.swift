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

public typealias RowEntityHandle = (RowEntity) -> Void

public let CONST_titleInputCellIdentifier = "titleInputCellIdentifier"

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
    public let selectIndexPath: PublishSubject<IndexPath> = PublishSubject()

    // MARK: - Private Property
    private let disposeBag: DisposeBag = DisposeBag()
    private let tableViewModel: TableViewModel = TableViewModel()
    private var plistHelper: PlistHelper!
    private var tableView: UITableView {
        return tableViewModel.tableView
    }
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
}

// MARK: - Public Method
extension UniversalPlistTableView {
    
    /// Fetch commint dictionary informattion
    /// 提交 TableView 中的信息
    public func extractCommitInfomation() -> [String : Any] {
        return [:]
    }
    
    /// Setup SourceData from plist
    /// 从 plist 设置数据源
    public func install(plist plistName: String, inBundle bundle: Bundle?) throws {
        plistHelper = try PlistHelper(plist: plistName, inBundle: bundle)
        tableViewModel.sectionList = plistHelper.getSectionList()
    }
    
    /// Regist Cell
    /// 注册新的 cell
    public func regist<CellType>(cellClass aCell: CellType.Type, forIdentifier identifier: String) where CellType: UITableViewCell, CellType: PlistCellProtocol {
        tableView.register(aCell, forCellReuseIdentifier: identifier)
    }
    
    /// Regist verification
    /// 注册验证逻辑
    public func regist(verificationClass aVerification: ValidatorProtocol, forSegue segue: String) {
        
    }
}

// MARK: - Private Method
extension UniversalPlistTableView {
    
    fileprivate func privateInit() {
        tableViewModel.toastAtIndexPath.bind(to: toastAtIndexPath).disposed(by: disposeBag)
        addSubview(tableViewModel.tableView)
        tableViewModel.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
