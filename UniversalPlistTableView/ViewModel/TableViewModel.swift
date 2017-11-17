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
    internal var toastMessage: PublishSubject<String> = PublishSubject()
    internal var toastAtIndexPath: PublishSubject<IndexPath> = PublishSubject()
    
    internal let configRowModel: PublishSubject<RowEntity> = PublishSubject()
    internal var sectionList: [SectionEntity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    internal let tableView: UITableView = {
        let tempTable: UITableView = UITableView(frame: CGRect.zero)
        let cellNib = UINib(nibName: "TitleInputCell", bundle: BundleHelper.resourcesBundle())
        tempTable.register(cellNib, forCellReuseIdentifier: CONST_titleInputCellIdentifier)
        return tempTable
    }()
}

// MARK: - TableView Delegate
extension TableViewModel: UITableViewDelegate {
    
}

extension TableViewModel: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = pickupRow(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier, for: indexPath)
        guard let plistCell = cell as? PlistCellProtocol else {
            fatalError("🐼🐼🐼UniversalPlistTableViewCell must coform protocol: PlistCellProtocol\n🐼🐼🐼我的超级牛逼无敌 Plist table view 注册的 Cell 必须实现协议 PlistCellProtocol, 不实现就不让你用哟, 我的哥")
        }
        plistCell.cellModel.value = rowModel
        
        if let vefifier = rowModel.verifier {
            vefifier.verificationResult.asObservable()
                .subscribe(onNext: bindVerifier(at: indexPath))
                .disposed(by: plistCell.disposeBag)
        }
        return cell
    }
}

// MARK: - Public Method
extension TableViewModel {
    
}

// MARK: - Private Method
extension TableViewModel {
    
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
            case .failed(let deferedMsg):
                self.toastMessage.onNext(deferedMsg)
                self.toastAtIndexPath.onNext(indexPath)
            }
        }
    }
}
