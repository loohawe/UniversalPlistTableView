//
//  UniversalCellProtocol.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit
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
public class BasePlistCell: UITableViewCell, PlistCellProtocol {
    
    /// Your cell must have this property
    /// 自定义的 cell 必须要有这个属性
    /// 当 Cell Reuse 的时候释放一些资源
    public var disposeBag: DisposeBag = DisposeBag()
    
    /// Override
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
    
    public func provideCustomModel() -> CustomEntityType {
        return EmptyCustomEntity()
    }
    
    public func bindCellModel(_ model: RowEntity) -> Void {
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
    }
    
    public func updateCell(withCustomProperty property: CustomEntityType) -> Void {
        /// Override this method to implement your custom behavior
        
    }
}

public protocol PlistCellProtocol {
    
    /// Original custom cell model
    /// 自定义的 Cell model, 其中初始值会初始化到 Cell 上.
    func provideCustomModel() -> CustomEntityType
    
    /// Cell bind to cellModel
    /// 从这里你要 Bind 相关属性到你的 Cell 上
    func bindCellModel(_ model: RowEntity) -> Void
    
    /// Cell custom model
    /// 从这里更新你自定义的属性, 比如 cell 背景色, cell 被点击了等等.
    func updateCell(withCustomProperty property: CustomEntityType) -> Void
    
}

/**
public protocol PlistCellUIProtocol {
    var titleLabel: UILabel! { get }
    var inputTextField: UITextField! { get }
    var subTitleLabel: UILabel! { get }
    var descLabel: UILabel! { get }
    var leadingIconImageView: UIImageView! { get }
    var trailingIconImageView: UIImageView! { get }
}

extension PlistCellUIProtocol {
    public var titleLabel: UILabel! { return UILabel() }
    public var inputTextField: UITextField! { return UITextField() }
    public var subTitleLabel: UILabel! { return UILabel() }
    public var descLabel: UILabel! { return UILabel() }
    public var leadingIconImageView: UIImageView! { return UIImageView() }
    public var trailingIconImageView: UIImageView! { return UIImageView() }
}**/



