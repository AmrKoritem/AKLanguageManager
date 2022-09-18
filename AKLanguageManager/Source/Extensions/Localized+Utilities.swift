//
//  Localized+Utilities.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import UIKit

public extension String {
    /// Localize the entire string
    var localized: String {
        AKLanguageManager.shared.shouldLocalizeNumbers ? expressionLocalized.numbersLocalized : expressionLocalized
    }

    /// Localize the expression as stated in the .strings file
    var expressionLocalized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Localize the numbers only
    var numbersLocalized: String {
        numbersLocalized(in: AKLanguageManager.shared.selectedLanguage)
    }

    /// Localize a formatted string
    func localized(with arguments: CVarArg...) -> String {
        let wordsLocalizedString = String.localizedStringWithFormat(self, arguments)
        return AKLanguageManager.shared.shouldLocalizeNumbers ? wordsLocalizedString.numbersLocalized : wordsLocalizedString
    }

    /// Localize the expression  to the designated language as stated in the .strings file. If the .strings file doesn't exist, this method returns nil
    func expressionLocalized(
        in language: Languages,
        tableName: String? = nil,
        comment: String = ""
    ) -> String? {
        guard let bundle = language.bundle else { return nil }
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: comment)
    }

    /// Localize the numbers only to the designated language
    func numbersLocalized(in language: Languages) -> String {
        let fullNsRange = NSRange(location: 0, length: count)
        let doubleRegex = try? NSRegularExpression(pattern: "[0-9]{1,}.[0-9]{1,}|[0-9]{1,}", options: [])
        let doubleMatches = doubleRegex?.matches(in: self, options: [], range: fullNsRange)
        let matches: [String]? = doubleMatches?.compactMap({ match in
            guard let strIndxRange = match.range.toStringIndexRange(string: self) else { return nil }
            return "\(self[strIndxRange])"
        })
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = language.locale
        var newStr = self
        matches?.forEach({ match in
            guard let doubleMatch = Double(match) else { return }
            let nsNumberMatch = NSNumber(value: doubleMatch)
            guard let localizedMatch = nf.string(from: nsNumberMatch) else { return }
            newStr = newStr.replacingOccurrences(of: match, with: localizedMatch)
        })
        return newStr
    }
}

public extension NSAttributedString {
    var localized: NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.mutableString.setString(string.localized)
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
    public var directionLocalized: UIImage? {
        guard AKLanguageManager.shared.isRightToLeft else { return self }
        isRightToLeft = true
        return imageFlippedForRightToLeftLayoutDirection()
    }
}

public extension NSTextAlignment {
    var localized: NSTextAlignment {
        guard self == .natural else { return self }
        return AKLanguageManager.shared.isRightToLeft ? .right : .left
    }
}

extension NSRange {
    func toStringIndexRange(string: String) -> Range<String.Index>? {
        guard let range = Range.init(self) else { return nil }
        let startRange = string.index(string.startIndex, offsetBy: range.lowerBound)
        let endRange = string.index(string.endIndex, offsetBy: range.upperBound - string.count)
        return startRange..<endRange
    }
}
