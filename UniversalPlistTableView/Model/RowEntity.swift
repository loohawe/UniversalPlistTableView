//
//  RowEntity.swift
//  UniversalPlistTableView
//
//  Created by luhao on 10/11/2017.
//

import UIKit
import RxSwift

/// Cell model 的属性
public enum RowEntityProperty: String {
    case title
    case subTitle
    case desc
    case inputText
    case inputPlaceHolder
    case inputVerificationRegex
    case inputVerificationDeferedMessage
    case leadingIcon
    case trailingIcon    
}

/// Cell model
/// Cell 对应的 Model
public class RowEntity: NSObject {
    
    public static func getEmptyEntity() -> RowEntity {
        return RowEntity()
    }
    
    /// Plist data
    @objc public var identifier: String = ""
    @objc dynamic public var accessoryType: UITableViewCellAccessoryType = .none
    @objc public var height: Double = 44.0
    public var rawTitle: String = "" {
        didSet {
            title = rawTitle.univDerive.content
            titleFont = rawTitle.univDerive.font
            titleColor = rawTitle.univDerive.color
        }
    }
    @objc dynamic public var title: String = ""
    @objc public var titleFont: UIFont?
    @objc public var titleColor: UIColor?
    public var rawSubTitle: String = "" {
        didSet {
            subTitle = rawSubTitle.univDerive.content
            subTitleFont = rawSubTitle.univDerive.font
            subTitleColor = rawSubTitle.univDerive.color
        }
    }
    @objc dynamic public var subTitle: String = ""
    @objc public var subTitleFont: UIFont?
    @objc public var subTitleColor: UIColor?
    public var rawDescription: String = "" {
        didSet {
            desc = rawDescription.univDerive.content
            descFont = rawDescription.univDerive.font
            descColor = rawDescription.univDerive.color
        }
    }
    @objc dynamic public var desc: String = ""
    @objc public var descFont: UIFont?
    @objc public var descColor: UIColor?
    public var rawInputText: String = "" {
        didSet {
            inputText = rawInputText.univDerive.content
            inputTextFont = rawInputText.univDerive.font
            inputTextColor = rawInputText.univDerive.color
        }
    }
    internal var preCurrectInputText: String = ""
    @objc dynamic public var inputText: String = ""
    @objc public var inputTextFont: UIFont?
    @objc public var inputTextColor: UIColor?
    @objc public var isRequired: Bool = false /// 是否要求必填
    @objc dynamic public var isClicked: Bool = true /// cell 是否可点击
    @objc dynamic public var isEditable: Bool = true /// cell 的 subview 是否可编辑
    @objc dynamic public var keyboardType: UIKeyboardType = .default
    @objc public var inputPlaceHolder: String = ""
    @objc public var inputVerificationRegex: String = ""
    @objc public var inputVerificationMaxCount: Int = -1
    @objc public var inputVerificationDeferedMessage: String = ""
    @objc dynamic public var commitKey: String = ""
    @objc public var leadingIcon: String = ""
    @objc public var trailingIcon: String = ""
    @objc public var didSelectSegue: String = ""
    @objc public var verificationSegue: String = ""
    
    /// Custom property
    /// 有些 cell 要存日期, 用这个属性
    internal var preCurrectDate: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic public var date: Date = Date.init(timeIntervalSince1970: 0)
    /// 用户自定义数据, 比如用来控制颜色或者其他
    public var customEntity: CustomEntityType?
    
    public var indexPath: IndexPath = IndexPath(row: -1, section: -1)
    
    /// 所有的回调
    public var handleBox: HandleBox = HandleBox()
    
    /// 结束编辑的信号
    public var endEdit: PublishSubject<RowEntity> = PublishSubject()
    
    /// 弱持有所有的数据
    public weak var dataCenter: TableViewDataCenter? {
        didSet {
            dataCenterDisposeBag = DisposeBag()
            if let unwrapDataCenter = dataCenter {
                
                /// 每次验证的时候存一下上次正确的值
                beforeVerifyStoreCurrect()
                /// 触发验证的逻辑改为 textFied didEndEdit 的时候
                /// 验证不通过时, 通知到 Handle
                //verifiedFailedImplement()
                
                guard let customType = unwrapDataCenter.customModelTypes[identifier] else {
                    fatalError("DataCenter 中 customModelTypes 里存入了非 BaseCustomEntity 的子类")
                }
                customEntity = customType.init()
                customEntity!.rowEntity = self
            }
        }
    }
    
    /// 验证一下是否验证通过
    private var isVerified: Bool {
        return verifierEntity.verify(cellModel: self)
    }
    
    /// 验证一下是否验证通过, 包括验证是否必填, 验证不通过, 触发一次验证不通过的 handle
    public func verifyCheck() -> Bool {
        
        if isRequired {
            if inputText.isEmpty {
                self.verifyInputText()
                return false
            }
        }
        if isVerified {
            return true
        } else {
            self.verifyInputText()
            return false
        }
    }
    
    /// 拿出来我的验证器
    private var verifierEntity: ValidatorType {
        if let unwrapeDataCenter = dataCenter,
            let myVerifier = unwrapeDataCenter.verifiers[verificationSegue] {
            return myVerifier
        }
        return EmptyVerifier()
    }
    
    private var dataCenterDisposeBag: DisposeBag = DisposeBag()
    
    /// Life cycle
    override public func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        var mutableDic = keyedValues
        accessoryType = UITableViewCellAccessoryType(rawValue: mutableDic.fetchValueAndRemove(withKey: "accessoryType") ?? 0) ?? .none
        rawTitle = mutableDic.fetchValueAndRemove(withKey: "title") ?? ""
        rawSubTitle = mutableDic.fetchValueAndRemove(withKey: "subTitle") ?? ""
        rawDescription = mutableDic.fetchValueAndRemove(withKey: "description") ?? ""
        rawInputText = mutableDic.fetchValueAndRemove(withKey: "inputText") ?? ""
        
        if let tmpHeight: Double = mutableDic.fetchValueAndRemove(withKey: "height") {
            height = tmpHeight
        } else if let tmpHeight: Int = mutableDic.fetchValueAndRemove(withKey: "height") {
            height = Double(tmpHeight)
        }
        
        if let keybdTypeInt: Int = mutableDic.fetchValueAndRemove(withKey: "keyboardType"),
            let keyT = UIKeyboardType(rawValue: keybdTypeInt) {
            keyboardType = keyT
        }
        
        super.setValuesForKeys(mutableDic)
    }
    
    override public init() {
        super.init()
        privateInit()
    }
    
    public convenience init(withDictionary dic: [String : Any]) {
        self.init()
        setValuesForKeys(dic)
        privateInit()
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

// MARK: - Private method
extension RowEntity {
    
    private func privateInit() {
    }
    
    /// 把最后一次验证通过的值存下来
    private func beforeVerifyStoreCurrect() {
        
        /// 把上一次验证通过的 InputText 值存下来
        rx.inputText
            //.debug()
            .filter({ [weak self] (_) -> Bool in
                //debugPrint("\(String(describing: self?.inputText))")
                return self?.isVerified ?? false
            })
            .subscribe(onNext: { [unowned self] (item) in
                self.preCurrectInputText = item ?? ""
            })
            .disposed(by: dataCenterDisposeBag)
        
        /// 把上一次验证通过的 date 值存下来
        rx.date
            .filter({ [weak self] (_) -> Bool in
                //debugPrint("\(String(describing: self?.date))")
                return self?.isVerified ?? false
            })
            .subscribe(onNext: { [unowned self] (item) in
                self.preCurrectDate = item ?? Date()
            })
            .disposed(by: dataCenterDisposeBag)
    }
    
    /// 验证不通过时, 通知到 Handle
    /**
    private func verifiedFailedImplement() {
        
        /// 触发验证
        rx.inputText
            .filter({ [weak self] (_) -> Bool in
                return !(self?.isVerified ?? true)
            })
            .subscribe(onNext: { [unowned self] (_) in
                self.verifyInputText()
            })
            .disposed(by: dataCenterDisposeBag)
        
        rx.date
            .filter({ [weak self] (_) -> Bool in
                return !(self?.isVerified ?? true)
            })
            .subscribe(onNext: { [unowned self] (_) in
                let identifier = HandleIdentifier(type: CellEventType.verified, keyPath: \RowEntity.date)
                self.implementHandle(withIdentifier: identifier)
            })
            .disposed(by: dataCenterDisposeBag)
    }**/
    
    /// 触发 InputText 的验证
    private func verifyInputText() {
        let identifier: HandleIdentifier<RowEntity, String> = HandleIdentifier(type: CellEventType.verified, keyPath: \RowEntity.inputText)
        self.implementHandle(withIdentifier: identifier)
    }
}

// MARK: - Public method
extension RowEntity {

    /// 执行 RowEntity 中的 Handle
    ///
    /// - Parameter identifier: Handle 的 identifier
    /// - Returns: Handle 存在并执行成功返回 True, 否则返回 False
    @discardableResult
    internal func implementHandle<RootType, ValueType>(withIdentifier identifier: HandleIdentifier<RootType, ValueType>) -> Bool {
        
        switch identifier.type {
        case .click:
            return implementClickHandle(withIdentifier: identifier)
            
        case .verified:
            return implementVerifiedHandle(withIdentifier: identifier)
            
        case .custom:
            return implementCustomHandle(withIdentifier: identifier)
        }
    }
    
    /// 执行自定义事件
    internal func implementClickHandle<RootType, ValueType>(withIdentifier identifier: HandleIdentifier<RootType, ValueType>) -> Bool {
        if let handle: RowEntityHandle = handleBox.implement(identifier: identifier) {
            /// 要传到 Block 里去, 弱持有一下
            unowned let shadowSelf = self
            /// 点击 Cell 的事件
            handle(shadowSelf)
            return true
        }
        return false
    }
    
    /// 执行验证失败的事件
    internal func implementVerifiedHandle<RootType, ValueType>(withIdentifier identifier: HandleIdentifier<RootType, ValueType>) -> Bool {
        if let handle: (((ValueType, ValueType, RowEntity)) -> Void) = handleBox.implement(identifier: identifier) {
            /// 要传到 Block 里去, 弱持有一下
            unowned let shadowSelf = self
            /// 验证的事件
            if let keyPath = identifier.keyPath {
                let keyPathValue = self[keyPath: keyPath]
                if keyPath == \RowEntity.inputText {
                    if let previousVaule = self.preCurrectInputText as? ValueType, let nowVaule = keyPathValue as? ValueType {
                        handle((previousVaule, nowVaule, shadowSelf))
                        return true
                    }
                } else if keyPath == \RowEntity.date {
                    if let previousVaule = self.preCurrectDate as? ValueType, let nowVaule = keyPathValue as? ValueType {
                        handle((previousVaule, nowVaule, shadowSelf))
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// 执行自定义事件
    internal func implementCustomHandle<RootType, ValueType>(withIdentifier identifier: HandleIdentifier<RootType, ValueType>) -> Bool {
        if let handle: (((ValueType, RowEntity)) -> Void) = handleBox.implement(identifier: identifier) {
            /// 要传到 Block 里去, 弱持有一下
            unowned let shadowSelf = self
            /// 自定义事件
            if let keyPath = identifier.keyPath {
                let keyPathValue = self.customEntity[keyPath: keyPath]
                if let nowValue = keyPathValue as? ValueType {
                    handle((nowValue, shadowSelf))
                    return true
                }
            }
        }
        return false
    }
    
    /// Reload 该 model 对应的 Cell
    public func reload(_ animation: UITableViewRowAnimation = .fade) {
        if let dataCen = dataCenter {
            dataCen.tableView.reloadRows(at: [indexPath], with: animation)
        }
    }
    
    /// 更新该 RowEntity 的 Custom Entity
    /// 并 reload 对应的 Cell
    public func updateCustomModel<CustomType>(_ animation: UITableViewRowAnimation = .fade, handle: ((CustomType) -> Void) = { _ in }) where CustomType: BaseCustomEntity {
        guard let unwrapCustom = customEntity as? CustomType else {
            fatalError("RowEntity 的 customEntity 必须是 BaseCustomEntity 的子类")
        }
        /// 修改 CustomEntity
        handle(unwrapCustom)
        reload(animation)
    }
    
    /// 触发验证的 Handle
    public func activateVerifiorHandle() -> Void {
        if !isVerified {
            verifyInputText()
            let identifier = HandleIdentifier(type: CellEventType.verified, keyPath: \RowEntity.date)
            self.implementHandle(withIdentifier: identifier)
        }
    }
}

// MARK: - RowEntityChainCallable
extension RowEntity: RowEntityChainCallable { }

// MARK: - FindRowEntityAbility
extension RowEntity: FindRowEntityAbility {
    public func getDataCenter() -> TableViewDataCenter {
        guard let realDataCenter = dataCenter else {
            fatalError("DataCenter 未赋值之前不允许使用")
        }
        return realDataCenter
    }
}
