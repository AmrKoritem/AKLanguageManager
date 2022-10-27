//
//  AKLanguageManager.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//  Copyright © 2017 Amr Koritem. All rights reserved.
//  GitHub: https://github.com/AmrKoritem/AKLanguageManager.git
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

// MARK: - Type aliases
public typealias ViewControllerFactory = (String?) -> UIViewController
public typealias Animation = (UIView) -> Void
public typealias LocalizationCompletionHandler = () -> Void

// MARK: - WindowAndTitle
/// Helper class to bundle both scene window and scen title in one place.
@objc
public class WindowAndTitle: NSObject {
    let window: UIWindow?
    let title: String?

    public init(window: UIWindow?, title: String?) {
        self.window = window
        self.title = title
        super.init()
    }
}

// MARK: - AKLanguageManagerProtocol
/// Protocol used for unit testing purposes.
protocol AKLanguageManagerProtocol {
    var shouldLocalizeNumbers: Bool { get set }
    var selectedLanguage: Language { get }
    var defaultLanguage: Language { get }
    var isRightToLeft: Bool { get }
    var locale: Locale { get }
    var bundle: Bundle? { get }
    var layoutDirection: LayoutDirection { get }
    func setLanguage(
        language: Language,
        for windowsAndTitles: [WindowAndTitle]?,
        viewControllerFactory: ViewControllerFactory?,
        animation: Animation?,
        completionHandler: LocalizationCompletionHandler?
    )
}

extension AKLanguageManagerProtocol {
    func setLanguage(language: Language) {
        setLanguage(language: language, for: nil, viewControllerFactory: nil, animation: nil, completionHandler: nil)
    }
}

// MARK: - AKLanguageManager
/// Language manager that can change the app language without restarting the app.
@objc
public final class AKLanguageManager: NSObject, ObservableObject, AKLanguageManagerProtocol {
    /// The singleton LanguageManager instance.
    @objc
    public static let shared = AKLanguageManager()
    /// Determines if numbers should be localized when localizing strings
    @objc
    public var shouldLocalizeNumbers: Bool = true
    /// Current app language.
    /// *Note, This property just to get the current lanuage,
    /// To set the language use:
    /// `setLanguage(language:, for:, viewControllerFactory:, animation:)`*
    @objc
    public private(set) var selectedLanguage: Language {
        get {
            let selectedLanguage = storage.string(forKey: .selectedLanguage) ?? ""
            return Language(identifier: selectedLanguage) ?? defaultLanguage
        }
        set {
            guard selectedLanguage != newValue else { return }
            storage.set(newValue.get.identifier, forKey: .selectedLanguage)
            objectWillChange.send()
        }
    }

    /// The default language that the app will run with first time.
    @objc
    public var defaultLanguage: Language {
        get {
            guard let defaultLanguage = storage.string(forKey: .defaultLanguage),
                  let language = Language(identifier: defaultLanguage) else {
                fatalError("Default language was not set.")
            }
            return language
        }
        set {
            swizzleUIKit()
            guard !isDefaultLanguageSet else {
                changeUIKitSemanticAttribute(to: selectedLanguage)
                return
            }
            storage.set(newValue.get.identifier, forKey: .defaultLanguage)
            selectedLanguage = newValue
            changeUIKitSemanticAttribute(to: newValue)
        }
    }

    /// The direction of the selected language.
    @objc
    public var isRightToLeft: Bool {
        selectedLanguage.get.isRightToLeft
    }

    /// The app locale to use it in dates and currency.
    @objc
    public var locale: Locale {
        selectedLanguage.get.locale
    }

    /// The app bundle.
    @objc
    public var bundle: Bundle? {
        selectedLanguage.get.bundle
    }

    /// The layout direction of the selected language.
    public var layoutDirection: LayoutDirection {
        selectedLanguage.get.layoutDirection
    }

    // MARK: - Internal Properties
    var storage: StorageProtocol = Storage.shared

    var isDefaultLanguageSet: Bool {
        let defaultLanguage = storage.string(forKey: .defaultLanguage)
        return defaultLanguage?.isEmpty == false
    }

    var isUIKitSwizzled = false

    lazy var defaultWindowsAndTitles: [WindowAndTitle] = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .compactMap { WindowAndTitle(window: $0.windows.first, title: $0.title) }

    // MARK: - Initializer
    private override init() {
        super.init()
    }

    // MARK: - Public Methods
    /// Set the current language of the app.
    /// - Parameters:
    ///   - language: The language that you need the app to run with.
    ///   - windowsAndTitles: The windows you want to change the `rootViewController` for. if you didn't
    ///                       set it, it will change the `rootViewController` for all the windows in the
    ///                       scenes.
    ///   - viewControllerFactory: A closure to make the `ViewController` for a specific `scene`,
    ///                            you can know for which `scene` you need to make the controller you can check
    ///                            the `title` sent to this clouser, this title is the `title` of the `scene`,
    ///                            so if there is 5 scenes this closure will get called 5 times
    ///                            for each scene window.
    ///   - animation: A closure with the current view to animate to the new view controller,
    ///                so you need to animate the view, move it out of the screen, change the alpha,
    ///                or scale it down to zero.
    ///   - completionHandler: A closure to be called when localization is done.
    @objc
    public func setLanguage(
        language: Language,
        for windowsAndTitles: [WindowAndTitle]?,
        viewControllerFactory: ViewControllerFactory? = nil,
        animation: Animation? = nil,
        completionHandler: LocalizationCompletionHandler? = nil
    ) {
        selectedLanguage = language
        guard let viewControllerFactory = viewControllerFactory else { return }
        changeUIKitSemanticAttribute(to: language)
        reloadUIKit(
            windowsAndTitles: windowsAndTitles,
            viewControllerFactory: viewControllerFactory,
            animation: animation,
            completionHandler: completionHandler
        )
    }

    /// Set the current language of the app.
    /// This function uses the default window scenes of the app.
    /// - Parameters:
    ///   - language: The language that you need the app to run with.
    ///   - viewControllerFactory: A closure to make the `ViewController` for a specific `scene`,
    ///                            you can know for which `scene` you need to make the controller you can check
    ///                            the `title` sent to this clouser, this title is the `title` of the `scene`,
    ///                            so if there is 5 scenes this closure will get called 5 times
    ///                            for each scene window.
    ///   - animation: A closure with the current view to animate to the new view controller,
    ///                so you need to animate the view, move it out of the screen, change the alpha,
    ///                or scale it down to zero.
    ///   - completionHandler: A closure to be called when localization is done.
    @objc
    public func setLanguage(
        language: Language,
        viewControllerFactory: ViewControllerFactory? = nil,
        animation: Animation? = nil,
        completionHandler: LocalizationCompletionHandler? = nil
    ) {
        setLanguage(
            language: language,
            for: defaultWindowsAndTitles,
            viewControllerFactory: viewControllerFactory,
            animation: animation,
            completionHandler: completionHandler)
    }
    
    // MARK: - Private Methods
    private func swizzleUIKit() {
        guard !isUIKitSwizzled else { return }
        isUIKitSwizzled = true
        Bundle.localize()
        UIView.localize()
    }

    private func changeUIKitSemanticAttribute(to language: Language) {
        UIView.appearance().semanticContentAttribute = language.get.semanticContentAttribute
    }

    private func reloadUIKit(
        windowsAndTitles: [WindowAndTitle]? = nil,
        viewControllerFactory: ViewControllerFactory,
        animation: Animation? = nil,
        completionHandler: LocalizationCompletionHandler? = nil
    ) {
        let windowsAndTitles = windowsAndTitles ?? defaultWindowsAndTitles
        windowsAndTitles.forEach { windowAndTitle in
            let viewController = viewControllerFactory(windowAndTitle.title)
            changeViewController(
                for: windowAndTitle.window,
                rootViewController: viewController,
                animation: animation,
                completionHandler: completionHandler)
        }
    }

    private func changeViewController(
        for window: UIWindow?,
        rootViewController: UIViewController,
        animation: Animation? = nil,
        completionHandler: LocalizationCompletionHandler? = nil
    ) {
        guard let snapshot = window?.snapshotView(afterScreenUpdates: true) else {
            completionHandler?()
            return
        }
        rootViewController.view.addSubview(snapshot)
        window?.rootViewController = rootViewController

        UIView.animate(
            withDuration: 0.5,
            animations: {
                animation?(snapshot)
            }) { _ in
                snapshot.removeFromSuperview()
                completionHandler?()
            }
    }
}
