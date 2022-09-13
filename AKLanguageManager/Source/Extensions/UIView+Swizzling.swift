//
//  UIView+Swizzling.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIView {
    static func localize() {
        let orginalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        let didAddMethod = class_addMethod(
            self,
            orginalSelector,
            method_getImplementation(swizzledMethod!),
            method_getTypeEncoding(swizzledMethod!))

        guard didAddMethod else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
            return
        }
        class_replaceMethod(
            self,
            swizzledSelector,
            method_getImplementation(orginalMethod!),
            method_getTypeEncoding(orginalMethod!))
    }

    @objc
    func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        localize()
    }
}
