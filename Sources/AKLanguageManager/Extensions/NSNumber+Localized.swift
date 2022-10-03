//
//  NSNumber+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 01/10/2022.
//

import Foundation

public extension NSNumber {
    /// Returns the localized string of the number for the current language.
    var localized: String? {
        localized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Returns the localized string of the number for the designated language.
    /// - Parameters:
    ///   - language: The language to which the string will be localized.
    ///   - numberStyle: The style of the returned number localization.
    /// - Returns:
    ///   - A string of the number localized in the designated language.
    func localized(in language: Language, style numberStyle: NumberFormatter.Style = .decimal) -> String {
        guard floor(doubleValue) != doubleValue else {
            return intValue.localized(in: language, style: numberStyle)
        }
        return doubleValue.localized(in: language, style: numberStyle)
    }

    /// Returns the localized string of the number for the designated locale.
    /// - Parameters:
    ///   - locale: The locale to which language the string will be localized.
    ///   - numberStyle: The style of the returned number localization.
    /// - Returns:
    ///   - A string of the number localized in the designated language.
    func localized(in locale: Locale, style numberStyle: NumberFormatter.Style = .decimal) -> String? {
        guard let language = Language(locale: locale) else { return nil }
        return localized(in: language, style: numberStyle)
    }
}
