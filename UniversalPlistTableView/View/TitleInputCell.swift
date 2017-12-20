//
//  TitleInputCell.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxSwift

public class TitleInputCell: UITableViewCell {

    public var cellModel: RowEntity = RowEntity()
    public var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

// MARK: - PlistCellProtocol
extension TitleInputCell: PlistCellProtocol {
    public func bindCellModel(_ model: RowEntity) -> Void {
        (model.rx.title).debug()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
//        (model.rx.inputText)
//            .debug()
//            .bind(to: inputTextField.rx.text)
//            .disposed(by: disposeBag)
        
        (inputTextField.rx.text <--==--> model.rx.inputText)
            .disposed(by: disposeBag)
        
        inputTextField.placeholder = model.inputPlaceHolder
        
        cellModel = model
    }
}

/// MARK: - Private method
extension TitleInputCell {
}
