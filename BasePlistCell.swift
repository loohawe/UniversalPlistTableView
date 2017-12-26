//
//  BasePlistCell.swift
//  UniversalPlistTableView
//
//  Created by luhao on 26/12/2017.
//

import Foundation
import RxSwift

/*!
 * Base cell
 * 所有的使用者继承这个 Cell
 * 只要你自定义的 Cell 里有这个名字
 * 那么你不用自己做任何绑定
 * 如果你自定义的 Cell 命名是以下的名字之一
 * BasePlistCell 会自己帮你绑定好
 
 titleLabel: UILabel
 inputTextField: UITextField
 subTitleLabel: UILabel
 descLabel: UILabel
 leadingIconImageView: UIImageView
 trailingIconImageView: UIImageView
 
 */
open class BasePlistCell: UITableViewCell, PlistCellProtocol {
    
    /// Your cell must have this property
    /// 自定义的 cell 必须要有这个属性
    /// 当 Cell Reuse 的时候释放一些资源
    open var disposeBag: DisposeBag = DisposeBag()
    
    /// Override
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
    
    open func provideCustomModel() -> CustomEntityType {
        return BaseCustomEntity()
    }
    
    open func bindCellModel(_ model: RowEntity) -> Void {
        disposeBag = DisposeBag()
        
        let selfMirror = Mirror(reflecting: self)
        var selfPropertyNameList: [String] = []
        for child in selfMirror.children {
            //debugPrint("属性名:\(child.label!)，值:\(child.value)")
            selfPropertyNameList.append("\(child.label!)")
        }
        
        if selfPropertyNameList.contains("titleLabel"),
            let titleLabel = value(forKey: "titleLabel") as? UILabel {
            model.rx.title
                //.debug()
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("inputTextField"),
            let inputTextField = value(forKey: "inputTextField") as? UITextField {
            inputTextField.keyboardType = model.keyboardType
            (inputTextField.rx.text <--==--> model.rx.inputText)
                .disposed(by: disposeBag)
            
            inputTextField.placeholder = model.inputPlaceHolder
        }
        
        if selfPropertyNameList.contains("subTitleLabel"),
            let subTitleLabel = value(forKey: "subTitleLabel") as? UILabel {
            model.rx.subTitle
                //.debug()
                .bind(to: subTitleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("descLabel"),
            let descLabel = value(forKey: "descLabel") as? UILabel {
            model.rx.desc
                //.debug()
                .bind(to: descLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("leadingIconImageView"),
            let leadingIconImageView = value(forKey: "leadingIconImageView") as? UIImageView {
            model.rx.leadingIcon
                //.debug()
                .map { UIImage(named: $0 ?? "") }
                .bind(to: leadingIconImageView.rx.image)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("trailingIcon"),
            let trailingIconImageView = value(forKey: "trailingIcon") as? UIImageView {
            model.rx.trailingIcon
                //.debug()
                .map { UIImage(named: $0 ?? "") }
                .bind(to: trailingIconImageView.rx.image)
                .disposed(by: disposeBag)
        }
        
        /// 订阅是否可编辑
        model.rx.isEditable
            .subscribe(onNext: { [weak self] (isEdit) in
                guard let `self` = self else { return }
                let canEdit: Bool = isEdit ?? false
                
                self.contentView.subviews.forEach({ (itemView) in
                    if let someTextField = itemView as? UITextField {
                        
                        if !canEdit {
                            someTextField.endEditing(true)
                        }
                        someTextField.isEnabled = canEdit
                        
                    } else if let someTextView = itemView as? UITextView {
                        
                        if !canEdit {
                            someTextView.endEditing(true)
                        }
                        someTextView.isEditable = canEdit
                        
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    open func updateCell(withCustomProperty property: CustomEntityType) -> Void {
        /// Override this method to implement your custom behavior
        
    }
}
