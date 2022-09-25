//
//  StorageTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import XCTest
@testable import AKLanguageManager

class StorageTests: XCTestCase {
    let storage = Storage.shared

    override func setUp() {
        storage.userDefaults = MockUserDefaults()
    }

    func testFirstTimeSettingValue() {
        XCTAssertNil(storage.string(forKey: .defaultLanguage))
        let savedString1 = "test1"
        storage.set(savedString1, forKey: .defaultLanguage)
        XCTAssertNotNil(storage.string(forKey: .defaultLanguage))
        XCTAssertEqual(storage.string(forKey: .defaultLanguage), savedString1)
    }

    func testOverwritingValue() {
        let savedString1 = "test1"
        let savedString2 = "test2"
        storage.set(savedString1, forKey: .defaultLanguage)
        storage.set(savedString2, forKey: .defaultLanguage)
        XCTAssertNotNil(storage.string(forKey: .defaultLanguage))
        XCTAssertNotEqual(storage.string(forKey: .defaultLanguage), savedString1)
        XCTAssertEqual(storage.string(forKey: .defaultLanguage), savedString2)
    }

    func testSettingValueForDifferentKey() {
        let savedString1 = "test1"
        let savedString2 = "test2"
        storage.set(savedString1, forKey: .defaultLanguage)
        storage.set(savedString2, forKey: .selectedLanguage)
        XCTAssertNotNil(storage.string(forKey: .defaultLanguage))
        XCTAssertNotNil(storage.string(forKey: .selectedLanguage))
        XCTAssertNotEqual(storage.string(forKey: .defaultLanguage), savedString2)
        XCTAssertEqual(storage.string(forKey: .selectedLanguage), savedString2)
    }
}
