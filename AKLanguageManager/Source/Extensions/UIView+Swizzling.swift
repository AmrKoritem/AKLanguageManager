//
//  UIView+Swizzling.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIView {
    static func localize() {
        let originalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        swizzle(originalSelector, with: swizzledSelector, in: self)
    }

    @objc
    func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        localize()
    }
}
