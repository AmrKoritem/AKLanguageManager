//
//  UISegmentedControl+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UISegmentedControl {
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
            guard !newValue else { return }
            resetImagesHorizontalDirection()
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
        guard let title = titleForSegment(at: index) else { return }
        setTitle(title.localized, forSegmentAt: index)
    }

    public func localizeImage(at index: Int) {
        guard let image = imageForSegment(at: index), shouldLocalizeImagesDirection else { return }
        setImage(image.directionLocalized, forSegmentAt: index)
    }

    /// Reverts the image direction of the item at the specified index.
    public func revertImageHorizontalDirection(at index: Int) {
        guard let image = imageForSegment(at: index) else { return }
        setImage(image.horizontalDirectionReverted, forSegmentAt: index)
    }

    /// Reverts the images direction.
    public func revertImagesHorizontalDirection() {
        (0 ..< numberOfSegments).forEach { [weak self] in
            guard let image = self?.imageForSegment(at: $0) else { return }
            self?.setImage(image.horizontalDirectionReverted, forSegmentAt: $0)
        }
    }

    /// Resets the images direction.
    public func resetImagesHorizontalDirection() {
        (0 ..< numberOfSegments).forEach { [weak self] in
            guard let image = self?.imageForSegment(at: $0) else { return }
            self?.setImage(image.horizontalDirectionChanged(to: .leftToRight), forSegmentAt: $0)
        }
    }
}
