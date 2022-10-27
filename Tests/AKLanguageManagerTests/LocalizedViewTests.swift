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
        languageManager.storage = storage
    }

    func testDefaultLanguage() {
        let localizedView = makeLocalizedView(defaultLanguage: .en)
        XCTAssertEqual(languageManager.defaultLanguage, .en)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
        XCTAssertEqual(localizedView.languageManager.selectedLanguage, languageManager.selectedLanguage)
    }
}
