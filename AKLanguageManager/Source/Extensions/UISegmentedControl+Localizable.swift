//
//  UISegmentedControl+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UISegmentedControl {
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
            (0 ..< numberOfSegments).forEach { index in
                let image = imageForSegment(at: index)
                guard image?.isRightToLeft == true, !newValue else { return }
                let flippedImage = image?.imageFlippedForRightToLeftLayoutDirection()
                flippedImage?.isRightToLeft = false
                setImage(flippedImage, forSegmentAt: index)
            }
        }
    }

    open override func localize() {
        (0 ..< numberOfSegments).forEach { localizeSegmant(at: $0) }
    }

    public func localizeSegmant(at index: Int) {
        localizeTitle(at: index)
        localizeImage(at: index)
    }

    public func localizeTitle(at index: Int) {
        setTitle(titleForSegment(at: index)?.localized, forSegmentAt: index)
    }

    public func localizeImage(at index: Int) {
        guard shouldLocalizeImageDirection else { return }
        setImage(imageForSegment(at: index)?.directionLocalized, forSegmentAt: index)
    }
}
