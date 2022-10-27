//
//  NSTextAlignment+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 01/10/2022.
//

import UIKit

public extension NSTextAlignment {
    /// Returns an `NSTextAlignment` enum suitable for the current language.
    static var localized: NSTextAlignment {
        localized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Returns an `NSTextAlignment` enum suitable for the current language.
    var localized: NSTextAlignment {
        guard self == .natural else { return self }
        return .localized
    }

    /// Returns an `NSTextAlignment` enum suitable for the designated language.
    static func localized(in language: Language) -> NSTextAlignment {
        language.get.textAlignment
    }
}
