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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
    
    /// Original custom cell model
    /// 自定义的 Cell model, 其中初始值会初始化到 Cell 上.
    open class func customModelType() -> CustomEntityType.Type {
        return BaseCustomEntity.self
    }
    
    open func bindCellModel(_ model: RowEntity) -> Void {
        disposeBag = DisposeBag()
        
        let selfMirror = Mirror(reflecting: self)
        var selfPropertyNameList: [String] = []
        for child in selfMirror.children {
            //debugPrint("属性名:\(child.label!)，值:\(child.value)")
            selfPropertyNameList.append("\(child.label!)")
        }
        
        if selfPropertyNameList.contains("up_titleLabel"),
            let titleLabel = value(forKey: "up_titleLabel") as? UILabel {
            model.rx.title
                //.debug()
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("up_inputTextField"),
            let inputTextField = value(forKey: "up_inputTextField") as? UITextField {
            setupUPTextField(inputTextField, model: model)
            
            inputTextField.placeholder = model.inputPlaceHolder
        }
        
        if selfPropertyNameList.contains("up_inputTextView"),
            let inputTextView = value(forKey: "up_inputTextView") as? UITextView {
            
            setupUPTextView(inputTextView, model: model)
        }
        
        if selfPropertyNameList.contains("up_subTitleLabel"),
            let subTitleLabel = value(forKey: "up_subTitleLabel") as? UILabel {
            model.rx.subTitle
                //.debug()
                .bind(to: subTitleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("up_descLabel"),
            let descLabel = value(forKey: "up_descLabel") as? UILabel {
            model.rx.desc
                //.debug()
                .bind(to: descLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("up_leadingIconImageView"),
            let leadingIconImageView = value(forKey: "up_leadingIconImageView") as? UIImageView {
            model.rx.leadingIcon
                //.debug()
                .map { UIImage(named: $0 ?? "") }
                .bind(to: leadingIconImageView.rx.image)
                .disposed(by: disposeBag)
        }
        
        if selfPropertyNameList.contains("up_trailingIcon"),
            let trailingIconImageView = value(forKey: "up_trailingIcon") as? UIImageView {
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
        
        /// 设置 Cell 的 accessoryType
        self.accessoryType = model.accessoryType
        
        /// 设置 Cell 的键盘类型
        /// 并监听输入控件的 didEndEdit 事件
        self.contentView.subviews.forEach({ (itemView) in
            if let someTextField = itemView as? UITextField {
                /// 设置键盘类型
                someTextField.keyboardType = model.keyboardType
            } else if let someTextView = itemView as? UITextView {
                /// 设置键盘类型
                someTextView.keyboardType = model.keyboardType
            }
        })
    }
    
    /// Cell custom model
    /// 从这里更新你自定义的属性, 比如 cell 背景色, cell 被点击了等等.
    open func updateCell(_ rowModel: RowEntity, _ customModel: CustomEntityType) -> Void {
        /// 做一些自定义的操作
    }
    
    /// 设置 Cell 当中的 textField
    final public func setupUPTextField(_ someTextField: UITextField, model: RowEntity) {
        /// 订阅值改变的事件
        /// 最大字数限制
        someTextField.rx.text
            .subscribe(onNext: { [weak someTextField, weak model] (textStr) in
                guard let `someTextField` = someTextField, let `model` = model else { return }
                var passText = textStr
                if let `textStr` = textStr, model.inputVerificationMaxCount > 0 {
                    if textStr.count > model.inputVerificationMaxCount {
                        let endIndex = textStr.index(textStr.startIndex, offsetBy: model.inputVerificationMaxCount)
                        let currectCountText = String(textStr[..<endIndex])
                        someTextField.text = currectCountText
                        passText = currectCountText
                    }
                }
                model.inputText = passText ?? ""
            })
            .disposed(by: disposeBag)
        model.rx.inputText.bind(to: someTextField.rx.text).disposed(by: disposeBag)
        
        /// 订阅结束编辑事件
        someTextField.rx
            .controlEvent(UIControlEvents.editingDidEnd)
            .subscribe(onNext: { [weak model] () in
                guard let `model` = model else { return }
                model.endEdit.onNext(model)
                model.activateVerifiorHandle()
            })
            .disposed(by: disposeBag)
    }
    
    /// 设置 Cell 当中的 TextView
    final public func setupUPTextView(_ someTextView: UITextView, model: RowEntity) {
        /// 订阅值改变的事件
        /// 最大字数限制
        someTextView.rx.text
            .subscribe(onNext: { [weak someTextView, weak model] (textStr) in
                guard let `someTextView` = someTextView, let `model` = model else { return }
                var passText = textStr
                if let `textStr` = textStr, model.inputVerificationMaxCount > 0 {
                    if textStr.count > model.inputVerificationMaxCount {
                        let endIndex = textStr.index(textStr.startIndex, offsetBy: model.inputVerificationMaxCount)
                        let currectCountText = String(textStr[..<endIndex])
                        someTextView.text = currectCountText
                        passText = currectCountText
                    }
                }
                model.inputText = passText ?? ""
            })
            .disposed(by: disposeBag)
        model.rx.inputText.bind(to: someTextView.rx.text).disposed(by: disposeBag)
        
        /// 订阅结束编辑事件
        someTextView.rx.didEndEditing
            .subscribe(onNext: { [weak model] () in
                guard let `model` = model else { return }
                model.endEdit.onNext(model)
                model.activateVerifiorHandle()
            })
            .disposed(by: disposeBag)
    }
}
