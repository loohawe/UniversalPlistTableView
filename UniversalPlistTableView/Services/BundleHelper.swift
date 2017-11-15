//
//  BundleHelper.swift
//  UniversalPlistTableView
//
//  Created by luhao on 15/11/2017.
//

import UIKit

class BundleHelper: NSObject {

    static func resourceBundleURL() -> URL? {
        let thisBundle = Bundle(for: BundleHelper.self)
        return thisBundle.url(forResource: "Resources", withExtension: "bundle")
    }
    
    static func resourcesBundle() -> Bundle? {
        if let bundleURL = resourceBundleURL() {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}
