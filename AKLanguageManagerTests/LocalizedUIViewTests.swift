//
//  LocalizedUIViewTests.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 24/09/2022.
//

import XCTest
@testable import AKLanguageManager

class LocalizedUIViewTests: XCTestCase {
    let languageManager = AKLanguageManager.shared
    let rtlLanguage = Language.ar
    let ltrLanguage = Language.en
    var storage: StorageProtocol!

    override func setUp() {
        Language.mainBundle = Bundle(for: type(of: self))
        storage = MockStorage()
        languageManager.storage = storage
        languageManager.defaultLanguage = ltrLanguage
    }

    func testUIView() {
        languageManager.setLanguage(language: rtlLanguage)
        let (view, label, imageView) = makeUIView()
        view.localize()
        XCTAssertEqual(label.text, "ليس مفتاحا")
        XCTAssertTrue(imageView.image?.isRightToLeft == true)
    }

    func testUILabel() {
        languageManager.setLanguage(language: rtlLanguage)
        let label = makeUILabel()
        label.localize()
        XCTAssertEqual(label.text, "ليس مفتاحا")
        XCTAssertEqual(label.textAlignment, .right)
    }

    func testUITextView() {
        languageManager.setLanguage(language: rtlLanguage)
        let textView = makeUITextView()
        textView.localize()
        XCTAssertEqual(textView.text, "ليس مفتاحا")
        XCTAssertEqual(textView.textAlignment, .right)
    }

    func testUITextField() {
        languageManager.setLanguage(language: rtlLanguage)
        let textField = makeUITextField()
        textField.localize()
        XCTAssertEqual(textField.text, "ليس مفتاحا")
        XCTAssertEqual(textField.textAlignment, .right)
    }

    func testUITabBar() {
        languageManager.setLanguage(language: rtlLanguage)
        let tabBar = makeUITabBar()
        tabBar.localize()
        XCTAssertEqual(tabBar.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar.items?.first?.image?.isRightToLeft == true)
        XCTAssertEqual(tabBar.items?.last?.title, "ترجم")
        XCTAssertTrue(tabBar.items?.last?.image?.isRightToLeft == true)
    }

    func testUITabBarShouldLocalizeImagesDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let tabBar1 = makeUITabBar()
        tabBar1.shouldLocalizeImagesDirection = false
        tabBar1.localize()
        XCTAssertEqual(tabBar1.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar1.items?.first?.image?.isRightToLeft == false)
        XCTAssertEqual(tabBar1.items?.last?.title, "ترجم")
        XCTAssertTrue(tabBar1.items?.last?.image?.isRightToLeft == false)
        let tabBar2 = makeUITabBar()
        tabBar2.localize()
        tabBar2.shouldLocalizeImagesDirection = false
        XCTAssertEqual(tabBar2.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar2.items?.first?.image?.isRightToLeft == false)
        XCTAssertEqual(tabBar2.items?.last?.title, "ترجم")
        XCTAssertTrue(tabBar2.items?.last?.image?.isRightToLeft == false)
    }

    func testUITabBarRevertImagesHorizontalDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let tabBar = makeUITabBar()
        tabBar.localize()
        XCTAssertTrue(tabBar.items?.first?.image?.isRightToLeft == true)
        XCTAssertTrue(tabBar.items?.last?.image?.isRightToLeft == true)
        tabBar.revertImagesHorizontalDirection()
        XCTAssertTrue(tabBar.items?.first?.image?.isRightToLeft == false)
        XCTAssertTrue(tabBar.items?.last?.image?.isRightToLeft == false)
        tabBar.revertImageHorizontalDirection(at: 0)
        XCTAssertTrue(tabBar.items?.first?.image?.isRightToLeft == true)
        XCTAssertTrue(tabBar.items?.last?.image?.isRightToLeft == false)
    }

    func testUIButton() {
        languageManager.setLanguage(language: rtlLanguage)
        let button = makeUIButton()
        button.localize()
        XCTAssertEqual(button.title(for: .normal), "ليس مفتاحا")
        XCTAssertEqual(button.title(for: .disabled), "٠١,١٠ مفتاح")
        XCTAssertTrue(button.image(for: .normal)?.isRightToLeft == true)
    }

    func testUIButtonShouldLocalizeImageDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let button1 = makeUIButton()
        button1.shouldLocalizeImageDirection = false
        button1.localize()
        XCTAssertEqual(button1.title(for: .normal), "ليس مفتاحا")
        XCTAssertEqual(button1.title(for: .disabled), "٠١,١٠ مفتاح")
        XCTAssertTrue(button1.image(for: .normal)?.isRightToLeft == false)
        let button2 = makeUIButton()
        button2.localize()
        button2.shouldLocalizeImageDirection = false
        XCTAssertEqual(button2.title(for: .normal), "ليس مفتاحا")
        XCTAssertEqual(button2.title(for: .disabled), "٠١,١٠ مفتاح")
        XCTAssertTrue(button2.image(for: .normal)?.isRightToLeft == false)
    }

    func testUIButtonRevertImagesHorizontalDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let button = makeUIButton()
        button.localize()
        XCTAssertTrue(button.image(for: .normal)?.isRightToLeft == true)
        button.revertImagesHorizontalDirection()
        XCTAssertTrue(button.image(for: .normal)?.isRightToLeft == false)
        button.revertImagesHorizontalDirection()
        XCTAssertTrue(button.image(for: .normal)?.isRightToLeft == true)
    }

    func testUISegmentedControl() {
        languageManager.setLanguage(language: rtlLanguage)
        let segmentedControl = makeUISegmentedControl()
        segmentedControl.localize()
        XCTAssertEqual(segmentedControl.titleForSegment(at: 0), "ليس مفتاحا")
        XCTAssertTrue(segmentedControl.imageForSegment(at: 1)?.isRightToLeft == true)
        XCTAssertEqual(segmentedControl.titleForSegment(at: 2), "ليس مفتاحا")
    }

    func testUISegmentedControlShouldLocalizeImagesDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let segmentedControl1 = makeUISegmentedControl()
        segmentedControl1.shouldLocalizeImagesDirection = false
        segmentedControl1.localize()
        XCTAssertEqual(segmentedControl1.titleForSegment(at: 0), "ليس مفتاحا")
        XCTAssertTrue(segmentedControl1.imageForSegment(at: 1)?.isRightToLeft == false)
        XCTAssertEqual(segmentedControl1.titleForSegment(at: 2), "ليس مفتاحا")
        let segmentedControl2 = makeUISegmentedControl()
        segmentedControl2.localize()
        segmentedControl2.shouldLocalizeImagesDirection = false
        XCTAssertEqual(segmentedControl2.titleForSegment(at: 0), "ليس مفتاحا")
        XCTAssertTrue(segmentedControl2.imageForSegment(at: 1)?.isRightToLeft == false)
        XCTAssertEqual(segmentedControl2.titleForSegment(at: 2), "ليس مفتاحا")
    }

    func testUISegmentedControlRevertImagesHorizontalDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let segmentedControl1 = makeUISegmentedControl()
        segmentedControl1.localize()
        XCTAssertTrue(segmentedControl1.imageForSegment(at: 1)?.isRightToLeft == true)
        segmentedControl1.revertImagesHorizontalDirection()
        XCTAssertTrue(segmentedControl1.imageForSegment(at: 1)?.isRightToLeft == false)
        segmentedControl1.revertImageHorizontalDirection(at: 1)
        XCTAssertTrue(segmentedControl1.imageForSegment(at: 1)?.isRightToLeft == true)
    }

    func testUIImageView() {
        let imageView = makeUIImageView()
        imageView.localize()
        XCTAssertTrue(imageView.image?.isRightToLeft == false)
        languageManager.setLanguage(language: rtlLanguage)
        imageView.localize()
        XCTAssertTrue(imageView.image?.isRightToLeft == true)
    }

    func testUIImageViewShouldLocalizeDirection() {
        languageManager.setLanguage(language: rtlLanguage)
        let imageView1 = makeUIImageView()
        imageView1.shouldLocalizeDirection = false
        imageView1.localize()
        XCTAssertTrue(imageView1.image?.isRightToLeft == false)
        let imageView2 = makeUIImageView()
        imageView2.localize()
        imageView2.shouldLocalizeDirection = false
        XCTAssertTrue(imageView2.image?.isRightToLeft == false)
    }

    func testUIImageViewHorizontalDirectionReverted() {
        languageManager.setLanguage(language: rtlLanguage)
        let imageView = makeUIImageView()
        imageView.localize()
        XCTAssertTrue(imageView.image?.isRightToLeft == true)
        imageView.revertImageHorizontalDirection()
        XCTAssertTrue(imageView.image?.isRightToLeft == false)
        imageView.revertImageHorizontalDirection()
        XCTAssertTrue(imageView.image?.isRightToLeft == true)
    }
}

