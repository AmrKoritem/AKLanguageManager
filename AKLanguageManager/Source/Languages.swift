//
//  Languages.swift
//
//  Created by Amr Koritem on 8/27/22.
//

import UIKit

/// Supported languages.
public enum Languages: String {
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

public extension Languages {
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
}
