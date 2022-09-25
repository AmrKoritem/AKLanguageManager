//
//  Global.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import UIKit
@testable import AKLanguageManager

func makeXibFileViewController() -> XibFileViewController {
    let nibName = String("\(XibFileViewController.self)")
    return XibFileViewController(nibName: nibName, bundle: Bundle(for: XibFileViewController.self))
}

extension Bundle {
    @objc
    static var test: Bundle {
        return Bundle(for: AKLanguageManagerTests.self)
    }

    static func swizzleMainBundleWithTestBundle() {
        let originalSelector = #selector(getter: main)
        let swizzledSelector = #selector(getter: test)
        swizzleClassSelector(originalSelector, with: swizzledSelector, in: self)
    }
}
