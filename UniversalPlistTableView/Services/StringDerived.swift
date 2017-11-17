//
//  StringDerived.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit

extension Derived where Base == String {
    
    internal var content: String {
        var dic: [String : Any] = [:]
        if let data = self.base.data(using: .utf8) {
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    dic = jsonDic
                }
            } catch {
                
            }
        }
        guard let realContent = dic["content"] as? String else {
            return base
        }
        return realContent
    }
    
    internal var font: UIFont? {
        var dic: [String : Any] = [:]
        if let data = self.base.data(using: .utf8) {
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    dic = jsonDic
                }
            } catch {
                
            }
        }
        guard let realFontSize = dic["fontSize"] as? CGFloat else {
            return nil
        }
        return UIFont.systemFont(ofSize: realFontSize)
    }
    
    internal var color: UIColor? {
        var dic: [String : Any] = [:]
        if let data = self.base.data(using: .utf8) {
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
                    dic = jsonDic
                }
            } catch {
                
            }
        }
        guard let realHxColor = dic["color"] as? String else {
            return nil
        }
        return UIColor(hexString: realHxColor)
    }
}

internal struct Derived<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

internal protocol DerivedCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// UniversalPlistTableView extensions.
    static var univDerive: Derived<CompatibleType>.Type { get set }
    
    var univDerive: Derived<CompatibleType> { get set }
}

extension DerivedCompatible {
    /// UniversalPlistTableView extensions.
    internal static var univDerive: Derived<Self>.Type {
        get {
            return Derived<Self>.self
        }
        set {
            
        }
    }
    
    internal var univDerive: Derived<Self> {
        get {
            return Derived(self)
        }
        set {
            
        }
    }
}

extension String: DerivedCompatible { }

extension UIColor {
    convenience init(hexString: String) {
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}
