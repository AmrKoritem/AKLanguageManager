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
        Language.mainBundle = Bundle(for: type(of: self))
    }

    func testBundle() {
        XCTAssertNotEqual(rtlLanguage.bundle, ltrLanguage.bundle)
    }

    func testDirection() {
        XCTAssertNotEqual(rtlLanguage.direction, ltrLanguage.direction)
    }

    func testLocale() {
        XCTAssertNotEqual(rtlLanguage.locale, ltrLanguage.locale)
    }

    func testIsRightToLeft() {
        XCTAssertTrue(rtlLanguage.isRightToLeft)
        XCTAssertFalse(ltrLanguage.isRightToLeft)
    }

    func testSemanticContentAttribute() {
        XCTAssertNotEqual(rtlLanguage.semanticContentAttribute, ltrLanguage.semanticContentAttribute)
    }

    func testOtherLanguages() {
        XCTAssertNotEqual(rtlLanguage.otherLanguages, ltrLanguage.otherLanguages)
        XCTAssertFalse(rtlLanguage.otherLanguages.contains(rtlLanguage))
        XCTAssertFalse(rtlLanguage.otherLanguages.contains(.deviceLanguage))
        XCTAssertFalse(ltrLanguage.otherLanguages.contains(ltrLanguage))
        XCTAssertFalse(ltrLanguage.otherLanguages.contains(.deviceLanguage))
    }
}
