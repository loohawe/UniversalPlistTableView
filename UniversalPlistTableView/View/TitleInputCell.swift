//
//  TitleInputCell.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxSwift

public class TitleInputCell: UITableViewCell, PlistCellProtocol {
    
    public var cellModel: Variable<RowEntity>!
    public var valueChanged: PublishSubject<RowEntity> = PublishSubject()
    public var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        cellModel.asObservable()
            .do(onNext: setupTitleLabel(titleLabel))
            .do(onNext: setupTextField(inputTextField))
            .subscribe(onNext: { (rowModel) in
                
            })
            .disposed(by: disposeBag)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}

extension TitleInputCell {
    
}
