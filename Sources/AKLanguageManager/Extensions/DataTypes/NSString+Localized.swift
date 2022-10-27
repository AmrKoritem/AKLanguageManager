//
//  NSString+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/10/2022.
//

import Foundation

// TODO: - Localize with arguments method in Obj-C
public extension NSString {
    /// Localize the entire string.
    @objc
    var localized: NSString {
        string.localized.nsString
    }

    /// Localize the expression as stated in the .strings file.
    @objc
    var expressionLocalized: NSString {
        string.expressionLocalized.nsString
    }

    /// Localize the numbers only.
    @objc
    var numbersLocalized: NSString {
        string.numbersLocalized.nsString
    }

    /// Localize the entire string to the designated language.
    @objc
    func localized(in language: Language) -> NSString {
        string.localized(in: language).nsString
    }

    /// Localize the expression  to the designated language as stated in the `.strings` file.
    /// - Parameters:
    ///    - language: The language according to which the string will be localized.
    ///    - tableName: The name of the `.strings` file where the localization of the string key is to be found.
    /// - Returns:
    ///    - If the `.strings` file doesn't exist, this method returns nil. Otherwise it returns the value found.
    @objc
    func expressionLocalized(in language: Language, tableName: String = "Localizable") -> NSString? {
        string.expressionLocalized(in: language, tableName: tableName)?.nsString
    }

    /// Gets all localizations for the string in all localization files existing in the designated language bundle.
    @objc
    func allExpressionLocalizes(in language: Language) -> NSDictionary? {
        string.allExpressionLocalizes(in: language) as NSDictionary
    }

    /// Localize the numbers only to the designated language.
    /// - Parameters:
    ///   - language: The language to which the string will be localized.
    ///   - numberStyle: The style of the returned number localization.
    /// - Returns:
    ///   - The string with all its numbers localized in the designated language.
    @objc
    func numbersLocalized(in language: Language, style numberStyle: NumberFormatter.Style = .decimal) -> NSString {
        string.numbersLocalized(in: language, style: numberStyle).nsString
    }
}

// MARK: - Helper apis
extension NSString {
    var string: String {
        self as String
    }
}

extension String {
    var nsString: NSString {
        self as NSString
    }
}
