//
//  UIButton+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIButton {
    open override func localize() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.localize(for: state)
        }
    }

    public func localize(for state: UIControl.State) {
        localizeImage(for: state)
        localizeTitle(for: state)
    }

    public func localizeTitle(for state: UIControl.State) {
        setTitle(title(for: state)?.localized, for: state)
        setAttributedTitle(attributedTitle(for: state)?.localized, for: state)
    }

    public func localizeImage(for state: UIControl.State) {
        setImage(image(for: state)?.directionLocalized, for: state)
    }
}

/// Avoided conforming to `CaseIterable` so as to keep this internal.
extension UIControl.State {
    static var allCases: [UIControl.State] {
        [.normal, .highlighted, disabled, .selected, .focused, .application, .reserved]
    }
}
