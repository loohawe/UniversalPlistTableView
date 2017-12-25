//
//  TitleInputFreeHeight.swift
//  UniversalPlistTableView
//
//  Created by luhao on 25/12/2017.
//

import UIKit
import RxSwift

public class TitleInputFreeHeight: BasePlistCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!  /// 父类对这个属性做了绑定, 不用自己绑了
    @IBOutlet weak var fireButton: UIButton! {
        didSet {
            
        }
    }
    @IBOutlet weak var contentLabel: UILabel!
    
    var cellModel: RowEntity!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override public func provideCustomModel() -> CustomEntityType {
        return TitleInputFace()
    }
    
    override public func bindCellModel(_ model: RowEntity) -> Void {
        super.bindCellModel(model)
        cellModel = model
    }
    
    override public func updateCell(withCustomProperty property: CustomEntityType) {
        
    }
    
}

public struct TitleInputFace: CustomEntityType {
    var fireAction: Any?
    var titleColor: UIColor = UIColor(hexString: "000000")
    var backgroundColor: UIColor = UIColor(hexString: "ffffff")
}
