//
//  UIView+Swizzle.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIView {
    static func localize() {
        let originalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        Swizzle.instance.selector(originalSelector, with: swizzledSelector, in: self)
    }

    @objc
    func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        localize()
    }
}
