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
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        let label = makeUILabel()
        let imageView = makeUIImageView()
        view.addSubview(label)
        view.addSubview(imageView)
        view.localize()
        XCTAssertEqual(label.text, "not key")
        XCTAssertTrue(imageView.image?.isRightToLeft == false)
    }

    func testUILabel() {
        let label1 = makeUILabel()
        label1.localize()
        XCTAssertEqual(label1.text, "not key")
        XCTAssertEqual(label1.textAlignment, .left)
        languageManager.setLanguage(language: rtlLanguage)
        let label2 = makeUILabel()
        label2.localize()
        XCTAssertEqual(label2.text, "ليس مفتاحا")
        XCTAssertEqual(label2.textAlignment, .right)
    }

    func testUITextView() {
        let textView1 = makeUITextView()
        textView1.localize()
        XCTAssertEqual(textView1.text, "not key")
        XCTAssertEqual(textView1.textAlignment, .left)
        languageManager.setLanguage(language: rtlLanguage)
        let textView2 = makeUITextView()
        textView2.localize()
        XCTAssertEqual(textView2.text, "ليس مفتاحا")
        XCTAssertEqual(textView2.textAlignment, .right)
    }

    func testUITextField() {
        let textField1 = makeUITextField()
        textField1.localize()
        XCTAssertEqual(textField1.text, "not key")
        XCTAssertEqual(textField1.textAlignment, .left)
        languageManager.setLanguage(language: rtlLanguage)
        let textField2 = makeUITextField()
        textField2.localize()
        XCTAssertEqual(textField2.text, "ليس مفتاحا")
        XCTAssertEqual(textField2.textAlignment, .right)
    }

    func testUITabBar() {
        let tabBar1 = makeUITabBar()
        tabBar1.localize()
        XCTAssertEqual(tabBar1.items?.first?.title, "not key")
        XCTAssertTrue(tabBar1.items?.first?.image?.isRightToLeft == false)
        languageManager.setLanguage(language: rtlLanguage)
        let tabBar2 = makeUITabBar()
        tabBar2.localize()
        XCTAssertEqual(tabBar2.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar2.items?.first?.image?.isRightToLeft == true)
        let tabBar3 = makeUITabBar()
        tabBar3.shouldLocalizeImagesDirection = false
        tabBar3.localize()
        XCTAssertEqual(tabBar3.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar3.items?.first?.image?.isRightToLeft == false)
        let tabBar4 = makeUITabBar()
        tabBar4.localize()
        tabBar4.shouldLocalizeImagesDirection = false
        XCTAssertEqual(tabBar4.items?.first?.title, "ليس مفتاحا")
        XCTAssertTrue(tabBar4.items?.first?.image?.isRightToLeft == false)
    }

    func testUIButton() {
        let button1 = makeUIButton()
        button1.localize()
        XCTAssertEqual(button1.title(for: .normal), "not key")
        XCTAssertEqual(button1.title(for: .disabled), "01.10 key")
        XCTAssertTrue(button1.image(for: .normal)?.isRightToLeft == false)
        languageManager.setLanguage(language: rtlLanguage)
        let button2 = makeUIButton()
        button2.localize()
        XCTAssertEqual(button2.title(for: .normal), "ليس مفتاحا")
        XCTAssertEqual(button2.title(for: .disabled), "٠١,١٠ مفتاح")
        XCTAssertTrue(button2.image(for: .normal)?.isRightToLeft == true)
        let button3 = makeUIButton()
        button3.shouldLocalizeImageDirection = false
        button3.localize()
        XCTAssertTrue(button3.image(for: .normal)?.isRightToLeft == false)
        let button4 = makeUIButton()
        button4.localize()
        button4.shouldLocalizeImageDirection = false
        XCTAssertTrue(button4.image(for: .normal)?.isRightToLeft == false)
    }

    func testUISegmentedControl() {
        let segmentedControl = makeUISegmentedControl()
        segmentedControl.localize()
        XCTAssertEqual(segmentedControl.titleForSegment(at: 0), "not key")
        XCTAssertNotNil(segmentedControl.imageForSegment(at: 1))
    }

    func testUIImageView() {
        let imageView1 = makeUIImageView()
        imageView1.localize()
        XCTAssertTrue(imageView1.image?.isRightToLeft == false)
        languageManager.setLanguage(language: rtlLanguage)
        imageView1.localize()
        XCTAssertTrue(imageView1.image?.isRightToLeft == true)
        let imageView2 = makeUIImageView()
        imageView2.shouldLocalizeDirection = false
        imageView2.localize()
        XCTAssertTrue(imageView2.image?.isRightToLeft == false)
        let imageView3 = makeUIImageView()
        imageView3.localize()
        imageView3.shouldLocalizeDirection = false
        XCTAssertTrue(imageView3.image?.isRightToLeft == false)
    }

    func makeUILabel() -> UILabel {
        let label = UILabel()
        label.text = "key"
        label.textAlignment = .natural
        label.sizeToFit()
        return label
    }

    func makeUITextView() -> UITextView {
        let textView = UITextView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        textView.text = "key"
        textView.textAlignment = .natural
        return textView
    }

    func makeUITextField() -> UITextField {
        let textField = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        textField.text = "key"
        textField.textAlignment = .natural
        return textField
    }

    func makeUITabBar() -> UITabBar {
        let tabBarController = UITabBarController()
        let firstViewController = UIViewController()
        firstViewController.tabBarItem.title = "key"
        firstViewController.tabBarItem.image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        let secondViewController = UIViewController()
        secondViewController.tabBarItem.title = "translate"
        secondViewController.tabBarItem.image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        tabBarController.viewControllers = [firstViewController, secondViewController]
        return tabBarController.tabBar
    }

    func makeUIButton() -> UIButton {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        button.setTitle("key", for: .normal)
        button.setTitle("latin-number-key", for: .disabled)
        button.setImage(image, for: .normal)
        return button
    }

    func makeUISegmentedControl() -> UISegmentedControl {
        let items = ["key", "translate", "key"]
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.setImage(image, forSegmentAt: 1)
        return segmentedControl
    }

    func makeUIImageView() -> UIImageView {
        let image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
        return UIImageView(image: image)
    }
}

