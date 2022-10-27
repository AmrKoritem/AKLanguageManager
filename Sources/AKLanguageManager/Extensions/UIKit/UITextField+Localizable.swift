//
//  UITextField+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITextField {
    @objc
    open override func localize() {
        localizeTextAlignment()
        localizeText()
        localizePlaceholder()
    }

    @objc
    public func localizeText() {
        text = text?.localized
        attributedText = attributedText?.localized
    }

    @objc
    public func localizePlaceholder() {
        placeholder = placeholder?.localized
        attributedPlaceholder = attributedPlaceholder?.localized
    }

    @objc
    public func localizeTextAlignment() {
        textAlignment = textAlignment.localized
    }
}
