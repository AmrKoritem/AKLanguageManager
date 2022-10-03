//
//  UIImage+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 01/10/2022.
//

import UIKit

extension UIImage {
    struct AssociatedKeys {
        static var isRightToLeft: UInt8 = 0
    }

    /// Check if the image is flipped in right to left direction.
    @objc
    public internal(set) var isRightToLeft: Bool {
        get {
            let isRightToLeft = objc_getAssociatedObject(self, &AssociatedKeys.isRightToLeft) as? Bool
            return isRightToLeft ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.isRightToLeft,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// The current image direction.
    public var horizontalDirection: Direction {
        isRightToLeft ? .rightToLeft : .leftToRight
    }

    /// Returns a version of the image that's flipped in the opposite direction.
    public var horizontalDirectionReverted: UIImage? {
        horizontalDirectionChanged(to: horizontalDirection.opposite)
    }

    /// Returns a version of the image that's flipped in right to left direction or left to right direction depending on the current language.
    public var directionLocalized: UIImage? {
        directionLocalized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Determines if the current `imageOrientation` is mirrored.
    public var isOrientationMirrored: Bool {
        imageOrientation.rawValue > 3
    }

    var horizontallyFlipped: UIImage? {
        guard let cgImage = cgImage else { return nil }
        // Using just `withHorizontallyFlippedOrientation()` causes sf-symbols to not change their orientation.
        return UIImage(
            cgImage: cgImage,
            scale: scale,
            orientation: withHorizontallyFlippedOrientation().imageOrientation)
    }

    /// Returns a version of the image that's flipped in right to left direction or left to right direction depending on the designated language.
    public func directionLocalized(in language: Language) -> UIImage? {
        horizontalDirectionChanged(to: language.isRightToLeft ? .rightToLeft : .leftToRight)
    }

    /// Returns a version of the image that's flipped in the direction specified.
    public func horizontalDirectionChanged(to direction: Direction) -> UIImage? {
        let shouldChangeDirection = horizontalDirection != direction
        guard shouldChangeDirection else { return self }
        let image = horizontallyFlipped
        image?.isRightToLeft = direction == .rightToLeft
        return image
    }

    public enum Direction {
        case rightToLeft
        case leftToRight

        public var opposite: Direction {
            self == .rightToLeft ? .leftToRight : .rightToLeft
        }
    }
}
