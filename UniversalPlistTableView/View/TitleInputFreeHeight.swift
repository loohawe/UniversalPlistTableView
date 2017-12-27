//
//  TitleInputFreeHeight.swift
//  UniversalPlistTableView
//
//  Created by luhao on 25/12/2017.
//

import UIKit
import RxSwift

public class TitleInputFreeHeight: BasePlistCell {
    
    
    @IBOutlet weak var up_titleLabel: UILabel!  /// 父类对这个属性做了绑定, 不用自己绑了
    @IBOutlet weak var fireButton: UIButton! {
        didSet {
            
        }
    }
    @IBOutlet weak var contentLabel: UILabel!
    
    var cellModel: RowEntity!
    var customEntity: TitleInputFace!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public override class func customModelType() -> CustomEntityType.Type {
        return TitleInputFace.self
    }
    
    override public func bindCellModel(_ model: RowEntity) -> Void {
        super.bindCellModel(model)
        
        cellModel = model
        cellModel.rx.desc.subscribe(onNext: { [weak self] (desc) in
            self?.contentLabel.text = desc
        }).disposed(by: disposeBag)
        
        model.rx.inputText.subscribe(onNext: { [weak self] (input) in
            self?.fireButton.setTitle(model.inputText, for: .normal)
        }).disposed(by: disposeBag)
        
        (fireButton.rx.tap).asObservable().subscribe(onNext: { [weak self] () in
            self?.customEntity.update(\TitleInputFace.fireAction)
        }).disposed(by: disposeBag)
    }
    
    override public func updateCell(_ rowModel: RowEntity, _ customModel: CustomEntityType) -> Void {
        customEntity = customModel as! TitleInputFace
        contentView.backgroundColor = customEntity.backgroundColor
    }
}

public class TitleInputFace: BaseCustomEntity {
    public var fireAction: Any?
    public var titleColor: UIColor = UIColor(hexString: "000000")
    public var backgroundColor: UIColor = UIColor(hexString: "ffffff")
}
