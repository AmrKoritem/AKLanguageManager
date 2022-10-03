//
//  Language.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

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

    /// The locale object associated to the language. Can be used in dates and currency.
    var locale: Locale {
        Locale(identifier: rawValue)
    }

    /// Indicates if the language is right to left.
    var isRightToLeft: Bool {
        direction == .rightToLeft
    }

    /// The semantic attribute of a language.
    var semanticContentAttribute: UISemanticContentAttribute {
        isRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }

    /// Array containing all other languages excluding `Languages.deviceLanguage`.
    var otherLanguages: [Language] {
        Language.all.filter { $0 != self }
    }

    /// Double numbers separator used in the language. For example: Dot is used in English as in 12.5.
    var doubleSeparator: String {
        // TODO: - Should work on double numbers representation in other languages as well.
        self == .ar ? "," : "."
    }

    /// Double numbers regex.
    var doubleRegex: String {
        // TODO: - Should work on double numbers representation in other languages as well.
        "\(singleDigitRegex){1,}\(doubleSeparator)\(singleDigitRegex){1,}"
    }

    /// Single digit regex.
    var singleDigitRegex: String {
        // TODO: - Should work on double numbers representation in other languages as well.
        self == .ar ? "[٠-٩]" : "[0-9]"
    }

    func numberRegex(minNumberOfDigits min: Int = 1, maxNumberOfDigits max: Int? = nil) -> String {
        // TODO: - Should work on numbers representation in other languages as well.
        let maxString = max != nil ? ",\(max!)" : ""
        let numberOfDigits = "{\(min)\(maxString)}"
        return "\(singleDigitRegex)\(numberOfDigits)"
    }
}