//
//  Localized+Utilities.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

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

    /// Localize a formatted string.
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

    /// Localize the expression  to the designated language as stated in the .strings file. If the .strings file doesn't exist, this method returns nil.
    func expressionLocalized(in language: Language, tableName: String = "Localizable") -> String? {
        guard let bundle = language.bundle,
              let url = bundle.url(forResource: tableName, withExtension: "strings"),
              let stringsDictionary = NSDictionary(contentsOf: url) as? [String: String] else { return nil }
        let mainBundleString = NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: "")
        return stringsDictionary[self] ?? mainBundleString
    }

    /// Gets all localizations for the string in all localization files existing in the designated language bundle.
    func allExpressionLocalizes(in language: Language) -> [String: String] {
        var localizedString: [String: String] = [:]
        guard let bundle = language.bundle,
              let filesURL = bundle.urls(forResourcesWithExtension: "strings", subdirectory: nil) else { return localizedString }
        filesURL.forEach { url in
            guard let stringsDict = NSDictionary(contentsOf: url) as? [String: String] else { return }
            let tableName = url.deletingPathExtension().lastPathComponent
            localizedString[tableName] = stringsDict[self]
        }
        return localizedString
    }

    /// Localize the numbers only to the designated language.
    func numbersLocalized(in language: Language) -> String {
        var localizedString = doublesPreparedForLocalization(in: language)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = language.locale
        let regex = "\(Language.en.numberRegex(minNumberOfDigits: 1))|\(Language.ar.numberRegex(minNumberOfDigits: 1))"
        let matches = matchesForRegex(regex).uniqued()
        matches.forEach { match in
            guard let nsNumberMatch = formatter.number(from: match),
                  let localizedMatch = formatter.string(from: nsNumberMatch) else { return }
            localizedString = localizedString.replacingOccurrences(of: match, with: localizedMatch)
        }
        return localizedString
    }

    private func doublesPreparedForLocalization(in language: Language) -> String {
        // TODO: - Should work on double numbers representation in other languages as well.
        var preparedString = self
        let regex = language != .ar ? Language.ar.doubleRegex : Language.en.doubleRegex
        let occurrence = language != .ar ? Language.ar.doubleSeparator : Language.en.doubleSeparator
        let replacement = language.doubleSeparator
        matchesForRegex(regex).uniqued().forEach { match in
            let modifiedMatch = match.replacingOccurrences(of: occurrence, with: replacement)
            preparedString = preparedString.replacingOccurrences(of: match, with: modifiedMatch)
        }
        return preparedString
    }
}

public extension NSAttributedString {
    /// Localize the entire string while keeping its attributes.
    var localized: NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.mutableString.setString(string.localized)
        return attributedString
    }

    /// Localize the entire string to the designated language while keeping its attributes.
    func localized(in language: Language) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.mutableString.setString(string.localized(in: language))
        return attributedString
    }
}

extension UIImage {
    struct AssociatedKeys {
        static var isRightToLeft: UInt8 = 0
    }

    /// Check if the image is flipped in right to left direction.
    @objc
    public internal(set) var isRightToLeft: Bool {
        get {
            let isRightToLeft = objc_getAssociatedObject(self, &AssociatedKeys.isRightToLeft) as? Bool
            return isRightToLeft ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.isRightToLeft,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// Returns a version of the image that's flipped in right to left direction or left to right direction depending on the current language.
    public var directionLocalized: UIImage {
        let language = AKLanguageManager.shared.selectedLanguage
        let image = directionLocalized(in: language)
        let shouldFlipImage = language.isRightToLeft && image.imageOrientation.rawValue < 4
        return shouldFlipImage ? image.withHorizontallyFlippedOrientation() : image
    }

    /// Returns a version of the image that's flipped in right to left direction or left to right direction depending on the designated language.
    public func directionLocalized(in language: Language) -> UIImage {
        let image = language.isRightToLeft ? withHorizontallyFlippedOrientation() : self
        image.isRightToLeft = language.isRightToLeft
        return image
    }
}

public extension NSTextAlignment {
    var localized: NSTextAlignment {
        guard self == .natural else { return self }
        return AKLanguageManager.shared.isRightToLeft ? .right : .left
    }
}

// MARK: - Helper methods
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
