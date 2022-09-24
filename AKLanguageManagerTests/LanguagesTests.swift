//
//  LanguagesTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LanguagesTests: XCTestCase {
    let rtlLanguage = Languages.ar
    let ltrLanguage = Languages.en

    override func setUp() {
        Languages.mainBundle = Bundle(for: type(of: self))
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
}
