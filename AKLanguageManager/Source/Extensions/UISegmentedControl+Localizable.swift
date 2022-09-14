//
//  UISegmentedControl+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UISegmentedControl {
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
        setImage(imageForSegment(at: index)?.directionLocalized, forSegmentAt: index)
    }
}
