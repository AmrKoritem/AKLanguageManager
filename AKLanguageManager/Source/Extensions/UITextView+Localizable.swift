//
//  UITextView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITextView {
    open override func localize() {
        localizeTextAlignment()
        localizeText()
    }

    public func localizeText() {
        text = text?.localized
        attributedText = attributedText?.localized()
    }

    public func localizeTextAlignment() {
        textAlignment = textAlignment.localized()
    }
}
