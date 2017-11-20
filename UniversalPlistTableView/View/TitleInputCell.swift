//
//  TitleInputCell.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit
import RxSwift

public class TitleInputCell: UITableViewCell, PlistCellProtocol {
    
    /// PlistCellProtocol
    public var cellModel: Variable<RowEntity> = Variable(RowEntity())
    public var valueChanged: PublishSubject<RowEntity> = PublishSubject()
    public var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        privateInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        bindViewModel()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    deinit {
        print("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

/// MARK: - Private method
extension TitleInputCell {
    
    fileprivate func privateInit() {
    }
    
    fileprivate func bindViewModel() {
        cellModel.asObservable()
            .do(onNext: setupTitleLabel(titleLabel))
            .do(onNext: setupTextField(inputTextField))
            .subscribe(onNext: { [weak self] (rowModel) in
                guard let `self` = self else { return }
                self.inputTextField.rx.text
                    .subscribe(onNext: { (inputText) in
                        rowModel.inputText = inputText ?? ""
                        rowModel.verifier.needVerify.onNext(rowModel)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
