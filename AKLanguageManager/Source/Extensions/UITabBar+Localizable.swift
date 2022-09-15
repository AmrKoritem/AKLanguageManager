//
//  UITabBar+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UITabBar {
    struct AssociatedKeys {
        static var shouldLocalizeImagesDirection: UInt8 = 0
    }

    /// Determines if the image should be horizontally flipped according to localization direction.
    @objc
    public var shouldLocalizeImagesDirection: Bool {
        get {
            let shouldLocalizeDirection = objc_getAssociatedObject(self, &AssociatedKeys.shouldLocalizeImagesDirection) as? Bool
            return shouldLocalizeDirection ?? true
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.shouldLocalizeImagesDirection,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            items?.forEach { $0.shouldLocalizeImageDirection = newValue }
        }
    }

    open override func localize() {
        items?.forEach { [weak self] in
            $0.shouldLocalizeImageDirection = self?.shouldLocalizeImagesDirection ?? true
            $0.localize()
        }
    }
}

extension UITabBarItem: Localizable {
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
            guard image?.isRightToLeft == true, !newValue else { return }
            image = image?.imageFlippedForRightToLeftLayoutDirection()
            image?.isRightToLeft = false
        }
    }

    public func localize() {
        localizeText()
        localizeImage()
    }

    public func localizeText() {
        title = title?.localized
    }

    public func localizeImage() {
        guard shouldLocalizeImageDirection else { return }
        image = image?.directionLocalized
    }
}
