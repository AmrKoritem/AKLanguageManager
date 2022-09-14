//
//  UITextField+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITextField {
    open override func localize() {
        localizeTextAlignment()
        localizeText()
        localizePlaceholder()
    }

    public func localizeText() {
        text = text?.localized
        attributedText = attributedText?.localized()
    }

    public func localizePlaceholder() {
        placeholder = placeholder?.localized
        attributedPlaceholder = attributedPlaceholder?.localized()
    }

    public func localizeTextAlignment() {
        textAlignment = textAlignment.localized()
    }
}
