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
