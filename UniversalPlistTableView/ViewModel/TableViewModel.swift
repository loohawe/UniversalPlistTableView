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
    internal var sectionList: [SectionEntity] = [] {
        didSet {
            disposeBag = DisposeBag()
            oberverRowModel(inSections: sectionList)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    internal let tableView: UITableView = {
        let tempTable: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
        let cellNib = UINib(nibName: "TitleInputCell", bundle: BundleHelper.resourcesBundle())
        tempTable.register(cellNib, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        //tempTable.register(TitleInputCell.self, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        return tempTable
    }()
    
    /// MARK: - Private property
    static var verifierTypes: [String : Any]?
    var disposeBag: DisposeBag = DisposeBag()
    
    
    /// MARK: - Override
    override init() {
        super.init()
        privateInit()
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
        TableViewModel.verifierTypes = nil
    }
}

// MARK: - TableView Delegate
extension TableViewModel: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowModel = pickupRow(indexPath)
        return CGFloat(rowModel.height)
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
        guard var plistCell = cell as? PlistCellProtocol else {
            fatalError("🐼🐼🐼UniversalPlistTableViewCell must coform protocol: PlistCellProtocol\n🐼🐼🐼我的超级牛逼无敌 Plist table view 注册的 Cell 必须实现协议 PlistCellProtocol, 不实现就不让你用哟, 我的哥")
        }
        plistCell.cellModel.value = rowModel
        
//        rowModel.verifier.verificationResult.asObservable()
//            .subscribe(onNext: bindVerifier(at: indexPath))
//            .disposed(by: plistCell.disposeBag)
        return cell
    }
}

// MARK: - Public Method
extension TableViewModel {
    
    /// Regist verification
    /// 注册验证逻辑
    public func regist<VerifierType>(verificationClass aVerification: VerifierType.Type, forSegue segue: String) where VerifierType: ValidatorProtocol {
        if TableViewModel.verifierTypes == nil {
            TableViewModel.verifierTypes = [:]
        }
        TableViewModel.verifierTypes![segue] = aVerification
    }
}

// MARK: - Private Method
extension TableViewModel {
    
    fileprivate func privateInit() {
        regist(verificationClass: CharacterCountVerifier.self, forSegue: "characterCountVerify")
    }
    
    fileprivate func pickupRow(_ indexPath: IndexPath) -> RowEntity {
        sectionList[indexPath.section].section = indexPath.section
        sectionList[indexPath.section].rows[indexPath.row].indexPath = indexPath
        return sectionList[indexPath.section].rows[indexPath.row]
    }
    
    fileprivate func bindVerifier(at indexPath: IndexPath) -> ((VerificationResult) -> Void) {
        return { [weak self] verification in
            guard let `self` = self else { return }
            switch verification {
            case .passed: ()
            case .failed:
                self.cellToastAtIndexPath.onNext(indexPath)
            }
        }
    }
    
    fileprivate func oberverRowModel(inSections sec: [SectionEntity]) {
        sec.forEach { (secItem) in
            secItem.rows.forEach({ (rowItem) in
                rowItem.verifier.verificationResult.asObservable()
                    .filter{ result in
                        if case .failed(_) = result {
                            return true
                        } else {
                            return false
                        }
                    }
                    .map({ (failed) -> IndexPath in
                        guard case .failed(let rowModel) = failed else { fatalError() }
                        return rowModel.indexPath
                    })
                    .bind(to: cellToastAtIndexPath)
                    .disposed(by: disposeBag)
            })
        }
    }
}
