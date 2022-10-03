//
//  LocalizedStringTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LocalizedStringTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    var storage: StorageProtocol!

    override func setUp() {
        Language.mainBundle = Bundle.test ?? Bundle(for: type(of: self))
        storage = MockStorage()
        languageManager.storage = storage
        languageManager.defaultLanguage = .en
        languageManager.shouldLocalizeNumbers = true
    }

    func testLocalized() {
        XCTAssertEqual("key".localized, "not key")

        languageManager.setLanguage(language: .ar)
        XCTAssertEqual("key".localized, "ليس مفتاحا")
        XCTAssertEqual("latin-number-key".localized, "٠١,١٠ مفتاح")
        XCTAssertEqual("latin-number-key".localized(in: .en), "01.10 key")

        languageManager.shouldLocalizeNumbers = false
        XCTAssertEqual("latin-number-key".localized, "01.10 مفتاح")
        XCTAssertEqual("latin-number-key".localized(in: .en), "01.10 key")
        XCTAssertEqual("latin-number-key".expressionLocalized, "latin-number-key".localized)
    }

    func testExpressionLocalized() {
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual("latin-number-key".expressionLocalized, "01.10 مفتاح")
        XCTAssertEqual("latin-number-key".expressionLocalized(in: .en), "01.10 key")

        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .ar).count, 2)
        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .ar)["Localizable"], "01.10 مفتاح")
        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .ar)["OtherLocalizables"], "02.20 مفتاح")

        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .en).count, 2)
        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .en)["Localizable"], "01.10 key")
        XCTAssertEqual("latin-number-key".allExpressionLocalizes(in: .en)["OtherLocalizables"], "02.20 key")
    }

    func testNumbersLocalized() {
        languageManager.setLanguage(language: .ar)
        XCTAssertNotEqual("latin-number-key".numbersLocalized, "٠١,١٠ key")
        XCTAssertEqual("latin-number-key".numbersLocalized, "latin-number-key")
        XCTAssertEqual("01.10 key".numbersLocalized, "٠١,١٠ key")
        XCTAssertEqual("٠١,١٠ key 01.10".numbersLocalized, "٠١,١٠ key ٠١,١٠")
        XCTAssertEqual("٠١,١٠ key".numbersLocalized(in: .en), "01.10 key")
        XCTAssertEqual("٠١,١٠ key 01.10".numbersLocalized(in: .en), "01.10 key 01.10")
    }

    func testLocalizedWithArguments() {
        XCTAssertEqual(
            "%d is a number, %.1f is a number, %ld is a number, %@ is a string".localized(with: 1, 1.1, 1, "test"),
            "1 is a number, 1.1 is a number, 1 is a number, test is a string")
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(
            "%d is a number, %.1f is a number, %ld is a number, %@ is a string".localized(with: 1, 1.1, 1, "test"),
            "١ رقم, ١,١ رقم, ١ رقم, test نص")
        XCTAssertEqual(
            "%d is a number, %.1f is a number, %ld is a number, %@ is a string".localized(in: .en, with: 1, 1.1, 1, "test"),
            "1 is a number, 1.1 is a number, 1 is a number, test is a string")

        languageManager.shouldLocalizeNumbers = false
        XCTAssertEqual(
            "%d is a number, %.1f is a number, %ld is a number, %@ is a string".localized(with: 1, 1.1, 1, "test"),
            "1 رقم, 1.1 رقم, 1 رقم, test نص")
    }

    func testLocalizedAttributedString() {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let attributedString = NSAttributedString(
            string: "latin-number-key",
            attributes: attributes)
        XCTAssertEqual(attributedString.localized.string, "01.10 key")

        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(attributedString.localized.string, "٠١,١٠ مفتاح")
        XCTAssertEqual(attributedString.localized.attributes.count, 1)
        XCTAssertEqual(
            attributedString.localized.forgroundColorAttribute,
            attributes[NSAttributedString.Key.foregroundColor] as? UIColor)
        XCTAssertEqual(attributedString.localized(in: .en).string, "01.10 key")
        XCTAssertEqual(attributedString.localized(in: .en).attributes.count, 1)
        XCTAssertEqual(
            attributedString.localized(in: .en).forgroundColorAttribute,
            attributes[NSAttributedString.Key.foregroundColor] as? UIColor)

        languageManager.shouldLocalizeNumbers = false
        XCTAssertEqual(attributedString.localized.string, "01.10 مفتاح")
        XCTAssertEqual(attributedString.localized.attributes.count, 1)
        XCTAssertEqual(
            attributedString.localized.forgroundColorAttribute,
            attributes[NSAttributedString.Key.foregroundColor] as? UIColor)
        XCTAssertEqual(attributedString.localized(in: .en).string, "01.10 key")
        XCTAssertEqual(attributedString.localized(in: .en).attributes.count, 1)
        XCTAssertEqual(
            attributedString.localized(in: .en).forgroundColorAttribute,
            attributes[NSAttributedString.Key.foregroundColor] as? UIColor)
    }
}

private extension NSAttributedString {
    var attributes: [NSAttributedString.Key: Any] {
        attributes(at: 0, effectiveRange: nil)
    }
    var forgroundColorAttribute: UIColor? {
        attributes[NSAttributedString.Key.foregroundColor] as? UIColor
    }
}
