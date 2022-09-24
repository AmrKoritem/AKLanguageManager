//
//  LocalizedUIImageTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 24/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LocalizedUIImageTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    var storage: StorageProtocol!

    override func setUp() {
        Language.mainBundle = Bundle(for: type(of: self))
        storage = MockStorage()
        languageManager.storage = storage
        languageManager.defaultLanguage = .en
    }

    func testUIImageLocalized() {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized.isRightToLeft == false)
        languageManager.setLanguage(language: .ar)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized.isRightToLeft == true)
    }

    func testUIImageLocalizedIn() {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        XCTAssertTrue(image?.isRightToLeft == false)
        XCTAssertTrue(image?.directionLocalized(in: .ar).isRightToLeft == true)
        XCTAssertTrue(image?.directionLocalized(in: .en).isRightToLeft == false)
    }
}
