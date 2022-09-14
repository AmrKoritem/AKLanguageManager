//
//  UITabBar+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITabBar {
    open override func localize() {
        items?.forEach { $0.localize() }
    }
}

extension UITabBarItem: Localizable {
    public func localize() {
        localizeText()
        localizeImage()
    }

    public func localizeText() {
        title = title?.localized
    }

    public func localizeImage() {
        image = image?.directionLocalized
    }
}
