//
//  Bundle+Swizzling.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import Foundation

extension Bundle {
    static func localize() {
        let originalSelector = #selector(localizedString(forKey:value:table:))
        let swizzledSelector = #selector(swizzledLocaLizedString(forKey:value:table:))
        swizzle(originalSelector, with: swizzledSelector, in: self)
    }

    @objc
    private func swizzledLocaLizedString(forKey key: String, value: String?, table: String?) -> String {
        guard let bundle = AKLanguageManager.shared.selectedLanguage.bundle else {
            return Bundle.main.swizzledLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.swizzledLocaLizedString(forKey: key, value: value, table: table)
    }
}

func swizzle(_ originalSelector: Selector, with swizzledSelector: Selector, in classInstance: AnyClass) {
    let originalMethod = class_getInstanceMethod(classInstance, originalSelector)
    let swizzledMethod = class_getInstanceMethod(classInstance, swizzledSelector)
    guard let originalMethod = originalMethod, let swizzledMethod = swizzledMethod else {
        assertionFailure("The methods are not found!")
        return
    }
    let didAddMethod = class_addMethod(
        classInstance,
        originalSelector,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod))

    guard didAddMethod else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
        return
    }
    class_replaceMethod(
        classInstance,
        swizzledSelector,
        method_getImplementation(originalMethod),
        method_getTypeEncoding(originalMethod))
}
