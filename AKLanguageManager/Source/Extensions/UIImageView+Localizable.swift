//
//  UIImageView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIImageView {
    struct AssociatedKeys {
        static var shouldLocalizeDirection: UInt8 = 0
    }

    /// Determines if the image should be horizontally flipped according to localization direction.
    @objc
    public var shouldLocalizeDirection: Bool {
        get {
            let shouldLocalizeDirection = objc_getAssociatedObject(self, &AssociatedKeys.shouldLocalizeDirection) as? Bool
            return shouldLocalizeDirection ?? true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.shouldLocalizeDirection,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            guard image?.isRightToLeft == true, !newValue else { return }
            image = image?.imageFlippedForRightToLeftLayoutDirection()
            image?.isRightToLeft = false
        }
    }

    open override func localize() {
        guard shouldLocalizeDirection else { return }
        image = image?.directionLocalized
    }
}
