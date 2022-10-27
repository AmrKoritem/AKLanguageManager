//
//  LanguagesTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LanguagesTests: XCTestCase {
    let rtlLanguage = Language.ar
    let ltrLanguage = Language.en

    override func setUp() {
        Language.mainBundle = Bundle.test ?? Bundle(for: type(of: self))
    }

    func testBundle() {
        XCTAssertNotEqual(rtlLanguage.get.bundle, ltrLanguage.get.bundle)
    }

    func testDirection() {
        XCTAssertNotEqual(rtlLanguage.get.direction, ltrLanguage.get.direction)
        XCTAssertNotEqual(rtlLanguage.get.layoutDirection, ltrLanguage.get.layoutDirection)
    }

    func testLocale() {
        XCTAssertNotEqual(rtlLanguage.get.locale, ltrLanguage.get.locale)
    }

    func testIsRightToLeft() {
        XCTAssertTrue(rtlLanguage.get.isRightToLeft)
        XCTAssertFalse(ltrLanguage.get.isRightToLeft)
    }

    func testSemanticContentAttribute() {
        XCTAssertNotEqual(rtlLanguage.get.semanticContentAttribute, ltrLanguage.get.semanticContentAttribute)
    }

    func testOtherLanguages() {
        XCTAssertNotEqual(rtlLanguage.get.otherLanguages, ltrLanguage.get.otherLanguages)
        XCTAssertFalse(rtlLanguage.get.otherLanguages.contains(rtlLanguage))
        XCTAssertFalse(ltrLanguage.get.otherLanguages.contains(ltrLanguage))
    }

    func testRTLLanguages() {
        XCTAssertTrue(LanguageWrapper.allRightToLeft.contains(rtlLanguage))
    }

    func testLTRLanguages() {
        XCTAssertTrue(LanguageWrapper.allLeftToRight.contains(ltrLanguage))
    }

    func testNumberRegex() {
        XCTAssertEqual(
            rtlLanguage.get.numberRegex(minNumberOfDigits: 1, maxNumberOfDigits: 2),
            rtlLanguage.get.numberRegex(minDigitsNumber: 1, maxDigitsNumber: 2))
    }
}
