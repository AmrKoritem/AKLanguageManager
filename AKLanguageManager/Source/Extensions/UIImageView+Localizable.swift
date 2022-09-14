//
//  UIImageView+Localizable.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

extension UIImageView {
    open override func localize() {
        image = image?.directionLocalized()
    }
}
