//
//  String+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import Foundation

public extension String {
    /// Localize the entire string.
    var localized: String {
        localized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Localize the expression as stated in the .strings file.
    var expressionLocalized: String {
        expressionLocalized(in: AKLanguageManager.shared.selectedLanguage) ?? self
    }

    /// Localize the numbers only.
    var numbersLocalized: String {
        numbersLocalized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Localize a formatted string in the designated language.
    /// - Parameters:
    ///    - language: The language according to which the string will be localized.
    ///    - arguments: The arguments needed to format the string.
    /// - Returns:
    ///    - The formtted string localized.
    func localized(
        in language: Language = AKLanguageManager.shared.selectedLanguage,
        with arguments: CVarArg...
    ) -> String {
        let expressionLocalization = String(format: expressionLocalized(in: language) ?? self, arguments)
        return AKLanguageManager.shared.shouldLocalizeNumbers ? expressionLocalization.numbersLocalized(in: language) : expressionLocalization
    }

    /// Localize the entire string to the designated language.
    func localized(in language: Language) -> String {
        let expressionLocalization = expressionLocalized(in: language) ?? self
        return AKLanguageManager.shared.shouldLocalizeNumbers ? expressionLocalization.numbersLocalized(in: language) : expressionLocalization
    }

    /// Localize the expression  to the designated language as stated in the `.strings` file.
    /// - Parameters:
    ///    - language: The language according to which the string will be localized.
    ///    - tableName: The name of the `.strings` file where the localization of the string key is to be found.
    /// - Returns:
    ///    - If the `.strings` file doesn't exist, this method returns nil. Otherwise it returns the value found.
    func expressionLocalized(in language: Language, tableName: String = "Localizable") -> String? {
        guard let bundle = language.get.bundle,
              let url = bundle.url(forResource: tableName, withExtension: "strings"),
              let stringsDictionary = NSDictionary(contentsOf: url) as? [String: String] else { return nil }
        let mainBundleString = NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: "")
        return stringsDictionary[self] ?? mainBundleString
    }

    /// Gets all localizations for the string in all localization files existing in the designated language bundle.
    func allExpressionLocalizes(in language: Language) -> [String: String] {
        var localizedString: [String: String] = [:]
        guard let bundle = language.get.bundle,
              let filesURL = bundle.urls(forResourcesWithExtension: "strings", subdirectory: nil) else { return localizedString }
        filesURL.forEach { url in
            guard let stringsDict = NSDictionary(contentsOf: url) as? [String: String] else { return }
            let tableName = url.deletingPathExtension().lastPathComponent
            localizedString[tableName] = stringsDict[self]
        }
        return localizedString
    }

    /// Localize the numbers only to the designated language.
    /// - Parameters:
    ///   - language: The language to which the string will be localized.
    ///   - numberStyle: The style of the returned number localization.
    /// - Returns:
    ///   - The string with all its numbers localized in the designated language.
    func numbersLocalized(in language: Language, style numberStyle: NumberFormatter.Style = .decimal) -> String {
        let allLanguagesDoubleRegex = _Language.allCases.compactMap { $0.objc }.enumerated()
            .compactMap { index, language in
                guard let numberRegex = language.get.numberRegex() else { return "" }
                return "\(numberRegex)|"
            }
            .uniqued() // Remove duplicates
            .joined() // Create a string
            .dropLast() // Remove the last `|`
        var localizedString = doublesPreparedForLocalization(in: language)
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = numberStyle
        numFormatter.locale = language.get.locale
        let matches = matchesForRegex(String(allLanguagesDoubleRegex)).uniqued()
        matches.forEach { match in
            guard let nsNumberMatch = numFormatter.number(from: match),
                  let localizedMatch = numFormatter.string(from: nsNumberMatch) else { return }
            localizedString = localizedString.replacingOccurrences(of: match, with: localizedMatch)
        }
        return localizedString
    }

    private func doublesPreparedForLocalization(in language: Language) -> String {
        // TODO: - Should work on double numbers representation in other languages as well.
        guard let regex = language != .ar ? Language.ar.get.doubleRegex : Language.en.get.doubleRegex,
              let occurrence = language != .ar ? Language.ar.get.decimalSeparator : Language.en.get.decimalSeparator,
              let replacement = language.get.decimalSeparator else { return self }
        var preparedString = self
        matchesForRegex(regex).uniqued().forEach { match in
            let modifiedMatch = match.replacingOccurrences(of: occurrence, with: replacement)
            preparedString = preparedString.replacingOccurrences(of: match, with: modifiedMatch)
        }
        return preparedString
    }
}

// MARK: - Helper apis
extension NSRange {
    func toStringIndexRange(string: String) -> Range<String.Index>? {
        guard let range = Range.init(self) else { return nil }
        let startRange = string.index(string.startIndex, offsetBy: range.lowerBound)
        let endRange = string.index(string.endIndex, offsetBy: range.upperBound - string.count)
        return startRange..<endRange
    }
}

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

extension String {
    func matchesForRegex(_ regex: String, atRange range: NSRange? = nil) -> [String] {
        let fullNSRange = range ?? NSRange(location: 0, length: count)
        let regularExpression = try? NSRegularExpression(pattern: regex, options: [])
        let results = regularExpression?.matches(in: self, options: [], range: fullNSRange)
        return results?.compactMap { match in
            guard let strIndxRange = match.range.toStringIndexRange(string: self) else { return nil }
            return "\(self[strIndxRange])"
        } ?? []
    }
}
