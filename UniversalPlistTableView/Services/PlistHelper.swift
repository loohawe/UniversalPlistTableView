//
//  PlistHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 14/11/2017.
//

import UIKit

internal class PlistHelper {
    
    var rawDictionaryList: [[String : Any]] = []

    init(plist plistName: String, inBundle bundle: Bundle?) throws {
        let `bundle` = bundle ?? Bundle.main
        guard let plistPath = bundle.path(forResource: plistName, ofType: "plist") else {
            throw PlistErrors.plistContentUncorrect
        }
        let array = NSArray(contentsOfFile: plistPath)
        guard let swiftList = array as? [[String : Any]] else {
            throw PlistErrors.plistContentUncorrect
        }
        rawDictionaryList = swiftList
    }
    
    deinit {
        debugPrint("deinit:🐔🐔🐔🐔🐔🐔🐔🐔🐔🐔\(type(of: self))")
    }
}

// MARK: - Public Method
extension PlistHelper {
    
    public func getSectionList() -> [SectionEntity] {
        return buildModels(from: rawDictionaryList)
    }
}

// MARK: - Private Method
extension PlistHelper {
    
    fileprivate func buildModels(from dictionaryList: [[String : Any]]) -> [SectionEntity] {
        var secList: [SectionEntity] = []
        dictionaryList.forEach { (itemDic) in
            secList.append(SectionEntity(withDictionary: itemDic))
        }
        return secList
    }
}
