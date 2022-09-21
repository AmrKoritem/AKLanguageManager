//
//  AKLanguageManagerTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 04/09/2022.
//

import XCTest
@testable import AKLanguageManager

class AKLanguageManagerTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    let window = UIWindow(frame: UIScreen.main.bounds)
    let windowTitle = "test"

    var storage: StorageProtocol!
    var testBundle: Bundle!

    override func setUp() {
        Bundle.swizzleMainBundleWithTestBundle()
        testBundle = Bundle.test
        storage = MockStorage()
        languageManager.storage = storage
    }

    func testSelectedLanguageNotSet() {
        languageManager.defaultLanguage = .en
        XCTAssertEqual(languageManager.defaultLanguage, .en)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
        selectedLanguageEqualDefaultLanguageTests()
    }

    func testSelectedLanguageSet() {
        languageManager.defaultLanguage = .en

        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(languageManager.defaultLanguage, .en)
        XCTAssertEqual(languageManager.selectedLanguage, .ar)
        selectedLanguageNotEqualDefaultLanguageTests()

        languageManager.setLanguage(language: .en)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
        selectedLanguageEqualDefaultLanguageTests()

        languageManager.defaultLanguage = .ar
        XCTAssertNotEqual(languageManager.defaultLanguage, .ar)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
    }

    func testUsingDeviceLanguageAsDefaultLanguage() {
        languageManager.defaultLanguage = .deviceLanguage
        XCTAssertEqual(languageManager.defaultLanguage, languageManager.deviceLanguage)
    }

    func testSetLanguageMethodWithDefaultWindows() {
        setLanguageMethodTests()
    }

    func testSetLanguageMethodWithProvidedWindows() {
        setLanguageMethodTests(for: [(window, windowTitle)])
    }

    func setLanguageMethodTests(for windows: [AKLanguageManager.WindowAndTitle]? = nil) {
        languageManager.defaultLanguage = .en
        if windows == nil {
            languageManager.defaultWindowsAndTitles = [(window, windowTitle)]
        }

        let firstViewController = makeXibFileViewController()
        window.makeKeyAndVisible()
        window.rootViewController = firstViewController

        firstViewController.loadViewIfNeeded()
        guard firstViewController.isViewLoaded else {
            return XCTFail("first view controller wasn't loaded")
        }
        XCTAssertEqual(firstViewController.explicitLabel.text, "translate")

        let secondViewController = makeXibFileViewController()
        let expectation = expectation(description: "localization done")
        languageManager.setLanguage(
            language: .ar,
            for: windows,
            viewControllerFactory: { [weak self] title in
                XCTAssertEqual(title, self?.windowTitle ?? "")
                return secondViewController
            },
            completionHandler: {
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)

        secondViewController.loadView()
        guard secondViewController.isViewLoaded else {
            return XCTFail("second view controller wasn't loaded")
        }
//        XCTAssertNotEqual(secondViewController.explicitLabel.text, "translate")
//        XCTAssertEqual(secondViewController.explicitLabel.text, "ترجم")
    }

    func selectedLanguageNotEqualDefaultLanguageTests() {
        XCTAssertNotEqual(languageManager.selectedLanguage, languageManager.defaultLanguage)
        XCTAssertNotEqual(languageManager.isRightToLeft, languageManager.defaultLanguage.isRightToLeft)
        XCTAssertNotEqual(languageManager.locale, languageManager.defaultLanguage.locale)
        XCTAssertNotEqual(languageManager.bundle, languageManager.defaultLanguage.bundle)
    }

    func selectedLanguageEqualDefaultLanguageTests() {
        XCTAssertEqual(languageManager.selectedLanguage, languageManager.defaultLanguage)
        XCTAssertEqual(languageManager.isRightToLeft, languageManager.defaultLanguage.isRightToLeft)
        XCTAssertEqual(languageManager.locale, languageManager.defaultLanguage.locale)
        XCTAssertEqual(languageManager.bundle, languageManager.defaultLanguage.bundle)
    }
}
