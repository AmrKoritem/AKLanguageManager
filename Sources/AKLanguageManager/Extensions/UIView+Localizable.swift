//
//  UIView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIView: Localizable {
    @objc
    open func localize() {
        subviews.forEach { $0.localize() }
    }
}
