//
//  DiscussCell.swift
//  UniversalPlistTableView
//
//  Created by luhao on 27/12/2017.
//

import UIKit
import RxSwift

public class DiscussCell: BasePlistCell {

    @IBOutlet weak var up_titleLabel: UILabel!
    @IBOutlet weak var up_inputTextView: UITextView!
    
    @IBOutlet weak var commitButton: UIButton!
    
    override public class func customModelType() -> CustomEntityType.Type {
        return CommitCellModel.self
    }
    
    override open func updateCell(_ rowModel: RowEntity, _ customModel: CustomEntityType) -> Void {
        let commitModel: CommitCellModel = customModel as! CommitCellModel
        commitButton.rx.tap
            .subscribe(onNext: { () in
                commitModel.update(\CommitCellModel.commitAction)
            })
            .disposed(by: disposeBag)
    }
}

public class CommitCellModel: BaseCustomEntity {
    public var commitAction: Any?
}
