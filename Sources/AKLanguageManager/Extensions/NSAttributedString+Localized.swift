//
//  NSAttributedString+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 01/10/2022.
//

import Foundation

public extension NSAttributedString {
    /// Localize the entire string while keeping its attributes.
    var localized: NSAttributedString {
        localized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Localize the entire string to the designated language while keeping its attributes.
    func localized(in language: Language) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.mutableString.setString(string.localized(in: language))
        return attributedString
    }
}
