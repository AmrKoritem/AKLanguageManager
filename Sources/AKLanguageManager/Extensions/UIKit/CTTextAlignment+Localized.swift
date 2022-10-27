//
//  CTTextAlignment+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 27/10/2022.
//

import UIKit

public extension CTTextAlignment {
    /// Returns an `CTTextAlignment` enum suitable for the current language.
    static var localized: CTTextAlignment {
        localized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Returns an `CTTextAlignment` enum suitable for the current language.
    var localized: CTTextAlignment {
        guard self == .natural else { return self }
        return .localized
    }

    /// Returns an `CTTextAlignment` enum suitable for the designated language.
    static func localized(in language: Language) -> CTTextAlignment {
        language.get.ctTextAlignment
    }
}
