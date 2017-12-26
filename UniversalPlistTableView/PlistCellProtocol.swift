//
//  UniversalCellProtocol.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit
import RxSwift

public protocol PlistCellProtocol: NSObjectProtocol {
    
    /// Cell bind to cellModel
    /// 从这里你要 Bind 相关属性到你的 Cell 上
    func bindCellModel(_ model: RowEntity) -> Void
    
    /// Cell custom model
    /// 从这里更新你自定义的属性, 比如 cell 背景色, cell 被点击了等等.
    func updateCell(_ rowModel: RowEntity, _ customModel: CustomEntityType) -> Void
    
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



