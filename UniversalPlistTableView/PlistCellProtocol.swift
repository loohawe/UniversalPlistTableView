//
//  UniversalCellProtocol.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit
import RxSwift

public protocol PlistCellProtocol {
    
    /// In
    /// Assign viewModel to Cell
    /// 给 Cell 赋值 viewModel
    var cellModel: Variable<RowEntity>! { get set }
    
    /// Out
    /// Send signal when cell input has changed
    /// 当 cell 的提交值改变的时候, 触发此信号
    var valueChanged: PublishSubject<RowEntity> { get set }
    var disposeBag: DisposeBag { get set }
}

/// Cell helper method
/// 把 cell 的 model 显示在 cell 上需要的一下帮助方法
/// 几乎涵盖了所有 RowEntity 的属性
/// 不要再写 Cell.titleLabel.text = cellModel.title 之类的方法啦 >_<
extension PlistCellProtocol {
    
    private func assignText(model: RowEntity, modelKey: String) -> ((UILabel) -> Void) {
        return { label in
            if let tempTitle = model.value(forKey: modelKey) as? String {
                label.text = tempTitle
            }
            if let tempFont = model.value(forKey: "\(modelKey)Font") as? UIFont {
                label.font = tempFont
            }
            if let tempColor = model.value(forKey: "\(modelKey)Color") as? UIColor {
                label.textColor = tempColor
            }
        }
    }
    
    private func assignImage(model: RowEntity, imageLocation: String) -> ((UIImageView) -> Void) {
        return { image in
            if let imageName = model.value(forKey: "\(imageLocation)Icon") as? String {
                image.image = UIImage(named: imageName)
            }
        }
    }
    
    public func setupTitleLabel(_ label: UILabel) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            self.assignText(model: rowModel, modelKey: "title")(label)
        }
    }
    
    public func setupSubTitleLabel(_ label: UILabel) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            self.assignText(model: rowModel, modelKey: "subTitle")(label)
        }
    }
    
    public func setupDescriptionLabel(_ label: UILabel) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            self.assignText(model: rowModel, modelKey: "desc")(label)
        }
    }
    
    public func setupTextField(_ textField: UITextField) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            textField.text = rowModel.inputText
            textField.placeholder = rowModel.inputPlaceHolder
            if let tempColor = textField.textColor {
                textField.textColor = tempColor
            }
            if let tempFont = textField.font {
                textField.font = tempFont
            }
        }
    }
    
    public func setAccessoryType(_ cell: UITableViewCell) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            cell.accessoryType = rowModel.accessoryType
        }
    }
    
    public func setupLeadingIcon(_ imageView: UIImageView) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            self.assignImage(model: rowModel, imageLocation: "leading")(imageView)
        }
    }
    
    public func setupTrailingIcon(_ imageView: UIImageView) -> RowEntityHandle {
        return { (rowModel: RowEntity) -> Void in
            self.assignImage(model: rowModel, imageLocation: "trailing")(imageView)
        }
    }
}