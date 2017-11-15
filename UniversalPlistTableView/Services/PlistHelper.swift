//
//  PlistHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit

internal class PlistHelper {
    
    var rawDictionary: [String : Any] = [:]

    init(plist plistName: String, inBundle bundle: Bundle?) throws {
        let `bundle` = bundle ?? Bundle.main
        guard let plistPath = bundle.path(forResource: plistName, ofType: "plist") else {
            throw PlistErrors.plistContentUncorrect
        }
        let dic = NSDictionary(contentsOfFile: plistPath)
        guard let swiftDic = dic as? [String : Any] else {
            throw PlistErrors.plistContentUncorrect
        }
        rawDictionary = swiftDic
    }
}

// MARK: - Public Method
extension PlistHelper {
    
    public func getSectionList() -> [SectionEntity] {
        return buildModels(from: rawDictionary)
    }
}

// MARK: - Private Method
extension PlistHelper {
    
    fileprivate func buildModels(from dictionary: [String : Any]) -> [SectionEntity] {
        return []
    }
}
