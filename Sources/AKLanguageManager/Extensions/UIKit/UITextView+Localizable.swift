//
//  UITextView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITextView {
    @objc
    open override func localize() {
        localizeTextAlignment()
        localizeText()
    }

    @objc
    public func localizeText() {
        text = text?.localized
        attributedText = attributedText?.localized
    }

    @objc
    public func localizeTextAlignment() {
        textAlignment = textAlignment.localized
    }
}
