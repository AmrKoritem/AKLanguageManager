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

    func testSetAndGetMethods() {
        // test initial state
        XCTAssertNil(storage.string(forKey: .defaultLanguage))
        // test initial set and get
        let savedString1 = "test1"
        storage.set(savedString1, forKey: .defaultLanguage)
        XCTAssertNotNil(storage.string(forKey: .defaultLanguage))
        XCTAssertEqual(storage.string(forKey: .defaultLanguage), savedString1)
        // test overwriting set values
        let savedString2 = "test2"
        storage.set(savedString2, forKey: .defaultLanguage)
        XCTAssertNotNil(storage.string(forKey: .defaultLanguage))
        XCTAssertNotEqual(storage.string(forKey: .defaultLanguage), savedString1)
        XCTAssertEqual(storage.string(forKey: .defaultLanguage), savedString2)
        // test set value for another key
        let savedString3 = "test3"
        storage.set(savedString3, forKey: .selectedLanguage)
        XCTAssertNotNil(storage.string(forKey: .selectedLanguage))
        XCTAssertNotEqual(storage.string(forKey: .defaultLanguage), savedString3)
        XCTAssertEqual(storage.string(forKey: .selectedLanguage), savedString3)
    }
}
