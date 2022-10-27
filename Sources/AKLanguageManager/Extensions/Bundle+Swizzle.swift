//
//  Bundle+Swizzle.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension Bundle {
    static func localize() {
        let originalSelector = #selector(localizedString(forKey:value:table:))
        let swizzledSelector = #selector(swizzledLocaLizedString(forKey:value:table:))
        Swizzle.instance.selector(originalSelector, with: swizzledSelector, in: self)
    }

    @objc
    private func swizzledLocaLizedString(forKey key: String, value: String?, table: String?) -> String {
        guard let bundle = AKLanguageManager.shared.selectedLanguage.get.bundle else {
            return Language.mainBundle.swizzledLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.swizzledLocaLizedString(forKey: key, value: value, table: table)
    }
}
