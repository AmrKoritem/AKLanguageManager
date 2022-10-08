//
//  Language.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import SwiftUI

/// Supported languages.
public enum Language: String, CaseIterable, Equatable {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id, ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml, am
    case enGB = "en-GB"
    case enAU = "en-AU"
    case enCA = "en-CA"
    case enIN = "en-IN"
    case frCA = "fr-CA"
    case esMX = "es-MX"
    case ptBR = "pt-BR"
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case zhHK = "zh-HK"
    case es419 = "es-419"
    case ptPT = "pt-PT"
    case deviceLanguage

    public init?(locale: Locale) {
        self.init(rawValue: locale.identifier)
    }
}

// Capturing the dependency for testing purposes.
extension Language {
    static var mainBundle = Bundle.main
}

public extension Language {
    /// Array containing all left to right languages excluding `Languages.deviceLanguage`.
    static var allLeftToRight: [Language] {
        all.filter { $0.direction == .leftToRight }
    }
    /// Array containing all right to left languages excluding `Languages.deviceLanguage`.
    static var allRightToLeft: [Language] {
        all.filter { $0.direction == .rightToLeft }
    }
    /// Array containing all supported languages excluding `Languages.deviceLanguage`.
    static var all: [Language] {
        allCases.filter { $0 != .deviceLanguage }
    }
    /// Language bundle.
    var bundle: Bundle? {
        let bundlePath = Language.mainBundle.path(forResource: rawValue, ofType: "lproj") ?? ""
        return Bundle(path: bundlePath)
    }
    /// The direction of the language.
    var direction: Locale.LanguageDirection {
        Locale.characterDirection(forLanguage: rawValue)
    }
    /// The layout direction of the language.
    var layoutDirection: LayoutDirection {
        direction == .rightToLeft ? .rightToLeft : .leftToRight
    }

    /// The locale object associated to the language. Can be used in dates and currency.
    var locale: Locale {
        Locale(identifier: rawValue)
    }

    /// Indicates if the language is right to left.
    var isRightToLeft: Bool {
        direction == .rightToLeft
    }

    /// The semantic attribute of the language.
    var semanticContentAttribute: UISemanticContentAttribute {
        isRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }

    /// Array containing all other languages excluding `Languages.deviceLanguage`.
    var otherLanguages: [Language] {
        Language.all.filter { $0 != self }
    }

    /// Double numbers decimal separator used in the language. For example: `.` is used in English as in 12.5.
    var decimalSeparator: String? {
        locale.decimalSeparator
    }

    /// Double numbers regex.
    var doubleRegex: String? {
        guard let decimalSeparator = decimalSeparator,
              let numberRegex = numberRegex(minNumberOfDigits: 0) else { return nil }
        return "\(numberRegex)\(decimalSeparator)\(numberRegex)"
    }

    /// Single digit regex.
    var singleDigitRegex: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        guard let nsZero = formatter.number(from: "\(Int.zero)"),
              let zero = formatter.string(from: nsZero),
              let nsNine = formatter.number(from: "9"),
              let nine = formatter.string(from: nsNine) else { return nil }
        return "[\(zero)-\(nine)]"
    }

    /// Number regex.
    /// - Parameters:
    ///   - minNumberOfDigits: The minimum amount of digits.
    ///   - maxNumberOfDigits: The maximum amount of digits.
    /// - Returns:
    ///     The number regex of the language.
    ///     If `maxNumberOfDigits` is zero, then the regex returned will allow maximum possible number of digits.
    ///     If the regex can't be retrieved, then nil is returned.
    func numberRegex(minNumberOfDigits min: Int = 1, maxNumberOfDigits max: Int? = nil) -> String? {
        guard let singleDigitRegex = singleDigitRegex else { return nil }
        guard max != .zero else { return "\(singleDigitRegex){\(min),}" }
        let maxString = max != nil ? ",\(max!)" : ""
        let numberOfDigits = "{\(min)\(maxString)}"
        return "\(singleDigitRegex)\(numberOfDigits)"
    }
}
