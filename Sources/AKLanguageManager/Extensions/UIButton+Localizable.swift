//
//  UIButton+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIButton {
    struct AssociatedKeys {
        static var shouldLocalizeImageDirection: UInt8 = 0
    }

    /// Determines if the image should be horizontally flipped according to localization direction.
    @objc
    public var shouldLocalizeImageDirection: Bool {
        get {
            let shouldLocalizeDirection = objc_getAssociatedObject(self, &AssociatedKeys.shouldLocalizeImageDirection) as? Bool
            return shouldLocalizeDirection ?? true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.shouldLocalizeImageDirection,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            guard !newValue else { return }
            resetImagesHorizontalDirection()
        }
    }

    open override func localize() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.localize(for: state)
        }
    }

    public func localize(for state: UIControl.State) {
        localizeTitle(for: state)
        localizeImage(for: state)
    }

    public func localizeTitle(for state: UIControl.State) {
        setTitle(title(for: state)?.localized, for: state)
        setAttributedTitle(attributedTitle(for: state)?.localized, for: state)
    }

    public func localizeImage(for state: UIControl.State) {
        guard shouldLocalizeImageDirection else { return }
        setImage(image(for: state)?.directionLocalized, for: state)
    }

    /// Reverts the image direction for the given state.
    public func revertImageHorizontalDirection(for state: UIControl.State) {
        setImage(image(for: state)?.horizontalDirectionReverted, for: state)
    }

    /// Reverts the images direction for all states.
    public func revertImagesHorizontalDirection() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.setImage(self?.image(for: state)?.horizontalDirectionReverted, for: state)
        }
    }

    /// Resets the images direction for all states.
    public func resetImagesHorizontalDirection() {
        UIControl.State.allCases.forEach { [weak self] state in
            self?.setImage(self?.image(for: state)?.horizontalDirectionChanged(to: .leftToRight), for: state)
        }
    }
}

/// Avoided conforming to `CaseIterable` so as to keep this internal.
extension UIControl.State {
    static var allCases: [UIControl.State] {
        [.normal, .highlighted, disabled, .selected, .focused, .application, .reserved]
    }
}
