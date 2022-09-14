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
        let fullNsRange = NSRange(location: 0, length: count)
        let doubleRegex = try? NSRegularExpression(pattern: "[0-9]{1,}.[0-9]{1,}|[0-9]{1,}", options: [])
        let doubleMatches = doubleRegex?.matches(in: self, options: [], range: fullNsRange)
        let matches: [String]? = doubleMatches?.compactMap({ match in
            guard let strIndxRange = match.range.toStringIndexRange(string: self) else { return nil }
            return "\(self[strIndxRange])"
        })
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = AKLanguageManager.shared.locale
        var newStr = self
        matches?.forEach({ match in
            guard let doubleMatch = Double(match) else { return }
            let nsNumberMatch = NSNumber(value: doubleMatch)
            guard let localizedMatch = nf.string(from: nsNumberMatch) else { return }
            newStr = newStr.replacingOccurrences(of: match, with: localizedMatch)
        })
        return newStr
    }

    /// Localize a formatted string
    func localized(with arguments: CVarArg...) -> String {
        let wordsLocalizedString = String.localizedStringWithFormat(self, arguments)
        return AKLanguageManager.shared.shouldLocalizeNumbers ? wordsLocalizedString.numbersLocalized : wordsLocalizedString
    }
}

public extension NSAttributedString {
    func localized() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.mutableString.setString(string.localized)
        return attributedString
    }
}

public extension UIImage {
    func directionLocalized() -> UIImage {
        guard AKLanguageManager.shared.isRightToLeft else { return self }
        return imageFlippedForRightToLeftLayoutDirection()
    }
}

public extension NSTextAlignment {
    func localized() -> NSTextAlignment {
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
