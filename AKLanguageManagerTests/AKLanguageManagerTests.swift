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
        selectedLanguageEqualDefaultLanguage()
    }

    func testSelectedLanguageSet() {
        languageManager.defaultLanguage = .en

        languageManager.setLanguage(language: .ar)
        XCTAssertEqual(languageManager.defaultLanguage, .en)
        XCTAssertEqual(languageManager.selectedLanguage, .ar)
        selectedLanguageNotEqualDefaultLanguage()

        languageManager.setLanguage(language: .en)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
        selectedLanguageEqualDefaultLanguage()

        languageManager.defaultLanguage = .ar
        XCTAssertNotEqual(languageManager.defaultLanguage, .ar)
        XCTAssertEqual(languageManager.selectedLanguage, .en)
    }

    func testUsingDeviceLanguageAsDefaultLanguage() {
        languageManager.defaultLanguage = .deviceLanguage
        XCTAssertEqual(languageManager.defaultLanguage, languageManager.deviceLanguage)
    }

    func testSetLanguageMethodWithDefaultWindows() {
        let windowTitle = "test"
        languageManager.defaultLanguage = .en
        languageManager.defaultWindowsAndTitles = [(window, windowTitle)]

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
            viewControllerFactory: { title in
                XCTAssertEqual(title, windowTitle)
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

    func testSetLanguageMethodWithProvidedWindows() {
        let windowTitle = "test"
        languageManager.defaultLanguage = .en

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
            for: [(window, windowTitle)],
            viewControllerFactory: { title in
                XCTAssertEqual(title, windowTitle)
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

    func selectedLanguageNotEqualDefaultLanguage() {
        XCTAssertNotEqual(languageManager.selectedLanguage, languageManager.defaultLanguage)
        XCTAssertNotEqual(languageManager.isRightToLeft, languageManager.defaultLanguage.isRightToLeft)
        XCTAssertNotEqual(languageManager.locale, languageManager.defaultLanguage.locale)
        XCTAssertNotEqual(languageManager.bundle, languageManager.defaultLanguage.bundle)
    }

    func selectedLanguageEqualDefaultLanguage() {
        XCTAssertEqual(languageManager.selectedLanguage, languageManager.defaultLanguage)
        XCTAssertEqual(languageManager.isRightToLeft, languageManager.defaultLanguage.isRightToLeft)
        XCTAssertEqual(languageManager.locale, languageManager.defaultLanguage.locale)
        XCTAssertEqual(languageManager.bundle, languageManager.defaultLanguage.bundle)
    }

    func makeXibFileViewController() -> XibFileViewController {
        let nibName = String("\(XibFileViewController.self)")
        return XibFileViewController(nibName: nibName, bundle: testBundle)
    }
}

extension Bundle {
    @objc
    static var test: Bundle {
        return Bundle(for: AKLanguageManagerTests.self)
    }

    static func swizzleMainBundleWithTestBundle() {
        let originalSelector = #selector(getter: main)
        let swizzledSelector = #selector(getter: test)
        swizzleClassSelector(originalSelector, with: swizzledSelector, in: self)
    }
}
