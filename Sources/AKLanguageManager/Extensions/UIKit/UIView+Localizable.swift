//
//  UIView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIView: Localizable {
    @objc
    open func localize() {
        subviews.forEach { $0.localize() }
    }
}

extension UIView {
    /// Changes the semantic attribute of the view and _optionally_ for its subviews in a recursive manner.
    /// - Parameters:
    ///   - language: The language for the desired semantic attribute.
    ///   - isRecursive: Determines if will change the semantic attribute for the subviews recursively.
    @objc
    public func changeSemanticAttribute(to language: Language, isRecursive: Bool = false) {
        semanticContentAttribute = language.get.semanticContentAttribute
        guard isRecursive else { return }
        subviews.forEach {
            $0.changeSemanticAttribute(to: language, isRecursive: isRecursive)
        }
    }
}
