//
//  Global.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import SwiftUI
@testable import AKLanguageManager

func makeXibFileViewController() -> XibFileViewController {
    let nibName = String("\(XibFileViewController.self)")
    return XibFileViewController(nibName: nibName, bundle: Bundle(for: XibFileViewController.self))
}

func makeUIView() -> (view: UIView, label: UILabel, imageView: UIImageView) {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
    let label = makeUILabel()
    let imageView = makeUIImageView()
    view.addSubview(label)
    view.addSubview(imageView)
    return (view: view, label: label, imageView: imageView)
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
    firstViewController.tabBarItem.selectedImage = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
    firstViewController.tabBarItem.landscapeImagePhone = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
    let secondViewController = UIViewController()
    secondViewController.tabBarItem.title = "translate"
    secondViewController.tabBarItem.image = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
    secondViewController.tabBarItem.selectedImage = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
    secondViewController.tabBarItem.landscapeImagePhone = UIImage(named: "image", in: Language.mainBundle, compatibleWith: nil)
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

func makeLocalizedView(defaultLanguage: Language) -> LocalizedView<Text> {
    LocalizedView(defaultLanguage) {
        Text("key")
    }
}
