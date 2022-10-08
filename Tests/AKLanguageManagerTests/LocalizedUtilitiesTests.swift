//
//  LocalizedUtilitiesTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 24/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LocalizedUtilitiesTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    var storage: StorageProtocol!

    override func setUp() {
        Language.mainBundle = Bundle.test ?? Bundle(for: type(of: self))
        storage = MockStorage()
        languageManager.storage = storage
        languageManager.isConfigured = false
        languageManager.configureWith(defaultLanguage: .en)
    }

    func testIntLocalized() {
        let int = 12
        XCTAssertEqual(int.localized, "12")
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(int.localized, "١٢")
        XCTAssertEqual(int.localized(in: .en), "12")
        XCTAssertEqual(int.localized(in: Language.en.locale) ?? "", "12")
    }

    func testDoubleLocalized() {
        let double = 12.2
        XCTAssertEqual(double.localized, "12.2")
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(double.localized, "١٢٫٢")
        XCTAssertEqual(double.localized(in: .en), "12.2")
        XCTAssertEqual(double.localized(in: Language.en.locale) ?? "", "12.2")
    }

    func testNSNumberDoubleLocalized() {
        let nsDouble = NSNumber(value: 12.2)
        XCTAssertEqual(nsDouble.localized, "12.2")
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(nsDouble.localized, "١٢٫٢")
        XCTAssertEqual(nsDouble.localized(in: .en), "12.2")
        XCTAssertEqual(nsDouble.localized(in: Language.en.locale) ?? "", "12.2")
    }

    func testNSNumberLocalized() {
        let nsInt = NSNumber(value: 12)
        XCTAssertEqual(nsInt.localized, "12")
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(nsInt.localized, "١٢")
        XCTAssertEqual(nsInt.localized(in: .en), "12")
        XCTAssertEqual(nsInt.localized(in: Language.en.locale) ?? "", "12")
    }

    func testUIImageLocalized() {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized?.isRightToLeft == false)
        languageManager.setLanguage(language: .ar)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized?.isRightToLeft == true)
    }

    func testUIImageLocalizedIn() {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized(in: .ar)?.isRightToLeft == true)
        XCTAssertTrue(image?.directionLocalized(in: .en)?.isRightToLeft == false)
    }

    func testNSTextAlignmentLocalized() {
        XCTAssertEqual(NSTextAlignment.localized, .left)
        XCTAssertEqual(NSTextAlignment.natural.localized, .left)
        XCTAssertNotEqual(NSTextAlignment.center.localized, .left)
        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(NSTextAlignment.localized, .right)
        XCTAssertEqual(NSTextAlignment.natural.localized, .right)
        XCTAssertNotEqual(NSTextAlignment.center.localized, .right)
    }

    func testNSTextAlignmentLocalizedIn() {
        XCTAssertEqual(NSTextAlignment.localized(in: .en), .left)
        XCTAssertEqual(NSTextAlignment.localized(in: .ar), .right)
    }
}
