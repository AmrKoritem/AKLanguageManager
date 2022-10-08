//
//  LocalizedViewTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 08/10/2022.
//

import XCTest
@testable import AKLanguageManager

class LocalizedViewTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    var storage: StorageProtocol!

    override func setUp() {
        storage = MockStorage()
        languageManager.observedLocalizer = ObservedLocalizer()
        languageManager.storage = storage
        languageManager.isConfigured = false
    }

    func testDefaultLanguage() {
        let localizedView = makeLocalizedView(defaultLanguage: .en)
        XCTAssertEqual(languageManager.defaultLanguage, .en)
        XCTAssertTrue(languageManager.isConfigured)
        XCTAssertEqual(languageManager.observedLocalizer?.selectedLanguage, .en)
        XCTAssertEqual(localizedView.localizer.selectedLanguage, languageManager.observedLocalizer?.selectedLanguage)
    }
}
