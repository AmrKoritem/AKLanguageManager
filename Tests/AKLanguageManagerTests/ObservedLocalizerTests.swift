//
//  ObservedLocalizerTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 08/10/2022.
//

import XCTest
@testable import AKLanguageManager

class ObservedLocalizerTests: XCTestCase {
    let observedLocalizer = ObservedLocalizer()
    var storage: StorageProtocol!

    override func setUp() {
        storage = MockStorage()
        observedLocalizer.languageManager?.storage = storage
        observedLocalizer.languageManager?.isConfigured = false
        observedLocalizer.languageManager?.configureWith(defaultLanguage: .en)
    }

    func testUUID() {
        XCTAssertNotEqual(observedLocalizer.uuid, observedLocalizer.uuid)
    }

    func testLayoutDirection() {
        XCTAssertEqual(observedLocalizer.layoutDirection, AKLanguageManager.shared.selectedLanguage.layoutDirection)
    }

    func testLocale() {
        XCTAssertEqual(observedLocalizer.locale, AKLanguageManager.shared.locale)
    }

    func testIsRightToLeft() {
        XCTAssertEqual(observedLocalizer.isRightToLeft, AKLanguageManager.shared.isRightToLeft)
    }

    func testSelectedLanguage() {
        XCTAssertEqual(observedLocalizer.selectedLanguage, AKLanguageManager.shared.selectedLanguage)
        AKLanguageManager.shared.setLanguage(language: .ar)
        XCTAssertEqual(observedLocalizer.selectedLanguage, AKLanguageManager.shared.selectedLanguage)
        observedLocalizer.selectedLanguage = .en
        XCTAssertEqual(observedLocalizer.selectedLanguage, AKLanguageManager.shared.selectedLanguage)
    }
}
