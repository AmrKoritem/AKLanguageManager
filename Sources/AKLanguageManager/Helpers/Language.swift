//
//  Language.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import SwiftUI

/// Supported languages.
@objc
public enum Language: Int {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id, ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml, am
    case enGB
    case enAU
    case enCA
    case enIN
    case frCA
    case esMX
    case ptBR
    case zhHans
    case zhHant
    case zhHK
    case es419
    case ptPT

    /// `LanguageWrapper` object that provides helper APIs for the language.
    public var get: LanguageWrapper {
        LanguageWrapper(language: self)
    }

    var swift: _Language {
        _Language.allCases[rawValue]
    }

    public init?(identifier: String) {
        guard let languageIndex = _Language(rawValue: identifier)?.index else { return nil }
        self.init(rawValue: languageIndex)
    }

    public init?(locale: Locale) {
        guard let languageIndex = _Language(rawValue: locale.identifier)?.index else { return nil }
        self.init(rawValue: languageIndex)
    }
}

enum _Language: String, CaseIterable, Equatable {
    case ar, en, nl, ja, ko, vi, ru, sv, fr, es, pt, it, de, da, fi, nb, tr, el, id, ms, th, hi, hu, pl, cs, sk, uk, hr, ca, ro, he, ur, fa, ku, arc, sl, ml, am
    case enGB = "en_GB"
    case enAU = "en_AU"
    case enCA = "en_CA"
    case enIN = "en_IN"
    case frCA = "fr_CA"
    case esMX = "es_MX"
    case ptBR = "pt_BR"
    case zhHans = "zh_Hans"
    case zhHant = "zh_Hant"
    case zhHK = "zh_HK"
    case es419 = "es_419"
    case ptPT = "pt_PT"

    var index: Int? {
        _Language.allCases.firstIndex(of: self)
    }

    var objc: Language? {
        guard let index = index else { return nil }
        return Language(rawValue: index)
    }
}

// Capturing the dependency for testing purposes.
extension Language {
    static var mainBundle = Bundle.main
}

/// Wrapper class with helper APIs for `Language` enum.
@objc
public class LanguageWrapper: NSObject {
    /// Note that the device language is deffrent than the app language.
    @objc
    public static var deviceLanguage: Language {
        let language = _Language(rawValue: Language.mainBundle.preferredLocalizations.first ?? "")
        return language?.objc ?? .en
    }

    /// Array containing all left to right languages.
    public static var allLeftToRight: [Language] {
        _Language.allCases.filter { LanguageWrapper(language: $0)?.direction == .leftToRight }.compactMap { $0.objc }
    }

    /// Array containing all right to left languages..
    public static var allRightToLeft: [Language] {
        _Language.allCases.filter { LanguageWrapper(language: $0)?.direction == .rightToLeft }.compactMap { $0.objc }
    }

    /// Language identifier.
    @objc
    public var identifier: String {
        language.swift.rawValue
    }

    /// Language bundle.
    @objc
    public var bundle: Bundle? {
        let bundlePath = Language.mainBundle.path(forResource: identifier, ofType: "lproj") ?? ""
        return Bundle(path: bundlePath)
    }

    /// The direction of the language.
    @objc
    public var direction: Locale.LanguageDirection {
        Locale.characterDirection(forLanguage: identifier)
    }

    /// The layout direction of the language.
    public var layoutDirection: LayoutDirection {
        direction == .rightToLeft ? .rightToLeft : .leftToRight
    }

    /// The locale object associated to the language. Can be used in dates and currency.
    @objc
    public var locale: Locale {
        Locale(identifier: identifier)
    }

    /// The text alignment of the language.
    @objc
    public var textAlignment: NSTextAlignment {
        language.get.isRightToLeft ? .right : .left
    }

    /// Indicates if the language is right to left.
    @objc
    public var isRightToLeft: Bool {
        direction == .rightToLeft
    }

    /// The semantic attribute of the language.
    @objc
    public var semanticContentAttribute: UISemanticContentAttribute {
        isRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }

    /// Array containing all other supported languages.
    public var otherLanguages: [Language] {
        _Language.allCases.filter { $0 != language.swift }.compactMap { $0.objc }
    }

    /// Double numbers decimal separator used in the language. For example: `.` is used in English as in 12.5.
    @objc
    public var decimalSeparator: String? {
        locale.decimalSeparator
    }

    /// Double numbers regex.
    @objc
    public var doubleRegex: String? {
        guard let decimalSeparator = decimalSeparator,
              let numberRegex = numberRegex(minDigitsNumber: 0) else { return nil }
        return "\(numberRegex)\(decimalSeparator)\(numberRegex)"
    }

    /// Single digit regex.
    @objc
    public var singleDigitRegex: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        guard let nsZero = formatter.number(from: "\(Int.zero)"),
              let zero = formatter.string(from: nsZero),
              let nsNine = formatter.number(from: "9"),
              let nine = formatter.string(from: nsNine) else { return nil }
        return "[\(zero)-\(nine)]"
    }

    @objc
    public var language: Language

    @objc
    public init(language: Language) {
        self.language = language
        super.init()
    }

    convenience init?(language: _Language) {
        guard let language = language.objc else { return nil }
        self.init(language: language)
    }

    /// An objective-c exposed version of `numberRegex(minDigitsNumber:maxDigitsNumber:)`.
    /// If you are writing a swift code, we recommend using `numberRegex(minDigitsNumber:maxDigitsNumber:)` instead.
    /// - Parameters:
    ///   - minNumberOfDigits: The minimum amount of digits.
    ///   - maxNumberOfDigits: The maximum amount of digits.
    /// - Returns:
    ///     The number regex of the language.
    ///     If `maxNumberOfDigits` is zero, then the regex returned will allow maximum possible number of digits.
    ///     If the regex can't be retrieved, then nil is returned.
    @objc
    func numberRegex(minNumberOfDigits min: Int, maxNumberOfDigits max: Int) -> String? {
        numberRegex(minDigitsNumber: min, maxDigitsNumber: max)
    }

    /// Number regex.
    /// - Parameters:
    ///   - minDigitsNumber: The minimum amount of digits.
    ///   - maxDigitsNumber: The maximum amount of digits.
    /// - Returns:
    ///     The number regex of the language.
    ///     If `maxDigitsNumber` is zero, then the regex returned will allow maximum possible number of digits.
    ///     If `maxDigitsNumber` is nil, then the regex returned will allow a number of digits equal to the `minDigitsNumber`.
    ///     If the regex can't be retrieved, then nil is returned.
    func numberRegex(minDigitsNumber min: Int = 1, maxDigitsNumber max: Int? = nil) -> String? {
        guard let singleDigitRegex = singleDigitRegex else { return nil }
        guard max != .zero else { return "\(singleDigitRegex){\(min),}" }
        let maxString = max != nil ? ",\(max!)" : ""
        let numberOfDigits = "{\(min)\(maxString)}"
        return "\(singleDigitRegex)\(numberOfDigits)"
    }
}
