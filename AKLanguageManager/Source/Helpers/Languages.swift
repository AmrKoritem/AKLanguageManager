//
//  Languages.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

/// Supported languages.
public enum Languages: String, CaseIterable, Equatable {
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
}

// For testing purposes
extension Languages {
    static var mainBundle = Bundle.main
}

public extension Languages {
    /// Language bundle.
    var bundle: Bundle? {
        let bundlePath = Languages.mainBundle.path(forResource: rawValue, ofType: "lproj") ?? ""
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

    /// Double numbers separator used in the language. For example: Dot is used in English as in 12.5.
    var doubleSeparator: String {
        // TODO: - Should work on double numbers representation in other languages as well.
        self == .ar ? "," : "."
    }

    /// Double numbers regex.
    var doubleRegex: String {
        // TODO: - Should work on double numbers representation in other languages as well.
        self == .ar ? "[٠-٩]{1,},[٠-٩]{1,}" : "[0-9]{1,}.[0-9]{1,}"
    }

    /// Array containing all other languages excluding `Languages.deviceLanguage`.
    var otherLanguages: [Languages] {
        var all = Languages.allCases
        all.removeAll { $0 == self || $0 == .deviceLanguage }
        return all
    }

    func numberRegex(minNumberOfDigits min: Int = 1, maxNumberOfDigits max: Int? = nil) -> String {
        // TODO: - Should work on numbers representation in other languages as well.
        let maxString = max != nil ? ",\(max!)" : ""
        let numberOfDigits = "{\(min)\(maxString)}"
        return self == .ar ? "[٠-٩]\(numberOfDigits)" : "[0-9]\(numberOfDigits)"
    }
}
