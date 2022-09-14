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

import UIKit

/// First of all, remember to add the `Localizable.strings` to your project, after adding the `Localizable.strings` file, select it then go to file inspector and below localization press localize, after that go to `PROJECT > Localisation` then add the languages you want to support (Arabic for example), dialog will appear to ask you which resource file you want to localize, select just the `Localizable.strings` file.
/// If your project is UIKit, then set your default language that your app will run first time in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method.
/// This Manager is not currently compatible with swifui projects.
public class AKLanguageManager {
    public typealias Animation = ((UIView) -> Void)
    public typealias ViewControllerFactory = ((String?) -> UIViewController)
    public typealias WindowAndTitle = (UIWindow?, String?)
    
    // MARK: - Properties
    /// The singleton LanguageManager instance.
    public static let shared = AKLanguageManager()
    /// Determines if numbers should be localized when localizing strings
    public var shouldLocalizeNumbers: Bool = true
    /// Current app language.
    /// *Note, This property just to get the current lanuage,
    /// To set the language use:
    /// `setLanguage(language:, for:, viewControllerFactory:, animation:)`*
    public private(set) var selectedLanguage: Languages {
        get {
            guard let selectedLanguage = storage.string(forKey: Languages.Keys.selectedLanguage),
                  let language = Languages(rawValue: selectedLanguage) else {
                fatalError("Did you set the default language for the app?")
            }
            return language
        }
        set {
            storage.set(newValue.rawValue, forKey: Languages.Keys.selectedLanguage)
        }
    }

    /// The default language that the app will run with first time.
    /// You need to set the `defaultLanguage` in the `AppDelegate`, specifically in
    /// the first line inside the `application(_:willFinishLaunchingWithOptions:)` method.
    public var defaultLanguage: Languages {
        get {
            guard let defaultLanguage = storage.string(forKey: Languages.Keys.defaultLanguage),
                  let language = Languages(rawValue: defaultLanguage) else {
                fatalError("Default language was not set.")
            }
            return language
        }
        set {
            let defaultLanguage = storage.string(forKey: Languages.Keys.defaultLanguage)
            guard defaultLanguage == nil else {
                // If the default language has been set before,
                // that means that the user opened the app before and maybe
                // he changed the language so here the `selectedLanguage` is being set.
                setLanguage(language: selectedLanguage)
                return
            }
            Bundle.localize()
            UIView.localize()
            let language = newValue == .deviceLanguage ? (deviceLanguage ?? .en) : newValue
            storage.set(language.rawValue, forKey: Languages.Keys.defaultLanguage)
            storage.set(language.rawValue, forKey: Languages.Keys.selectedLanguage)
            setLanguage(language: language)
        }
    }

    /// The device language is deffrent than the app language, to get the app language use `selectedLanguage`.
    public var deviceLanguage: Languages? {
        guard let deviceLanguage = Bundle.main.preferredLocalizations.first else { return nil }
        return Languages(rawValue: deviceLanguage)
    }

    /// The diriction of the selected language.
    public var isRightToLeft: Bool {
        selectedLanguage.isRightToLeft
    }

    /// The app locale to use it in dates and currency.
    public var locale: Locale {
        selectedLanguage.locale
    }

    /// The app bundle.
    public var bundle: Bundle? {
        selectedLanguage.bundle
    }

    // MARK: - Internal Properties
    /// Storage dependency
    var storage: StorageProtocol = Storage.shared

    // MARK: - Initializer
    private init() {}

    // MARK: - Public Methods
    /// Set the current language of the app
    /// - Parameters:
    ///   - language: The language that you need the app to run with.
    ///   - windows: The windows you want to change the `rootViewController` for. if you didn't
    ///              set it, it will change the `rootViewController` for all the windows in the
    ///              scenes.
    ///   - viewControllerFactory: A closure to make the `ViewController` for a specific `scene`,
    ///                            you can know for which `scene` you need to make the controller you can check
    ///                            the `title` sent to this clouser, this title is the `title` of the `scene`,
    ///                            so if there is 5 scenes this closure will get called 5 times
    ///                            for each scene window.
    ///   - animation: A closure with the current view to animate to the new view controller,
    ///                so you need to animate the view, move it out of the screen, change the alpha,
    ///                or scale it down to zero.
    public func setLanguage(
        language: Languages,
        for windows: [WindowAndTitle]? = nil,
        viewControllerFactory: ViewControllerFactory? = nil,
        animation: Animation? = nil
    ) {
        changeCurrentLanguageTo(language)
        guard let viewControllerFactory = viewControllerFactory else { return }
        getWindowsToChangeFrom(windows)?.forEach { windowAndTitle in
            let (window, title) = windowAndTitle
            let viewController = viewControllerFactory(title)
            changeViewController(
                for: window,
                rootViewController: viewController,
                animation: animation)
        }
    }
    
    // MARK: - Private Methods
    private func changeCurrentLanguageTo(_ language: Languages) {
        UIView.appearance().semanticContentAttribute = language.semanticContentAttribute
        selectedLanguage = language
    }

    private func getWindowsToChangeFrom(_ windows: [WindowAndTitle]?) -> [WindowAndTitle]? {
        guard windows == nil else { return windows }
        guard #available(iOS 13.0, *) else { return [(UIApplication.shared.keyWindow, nil)] }
        return UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .map({ ($0.windows.first, $0.title) })
    }

    private func changeViewController(
        for window: UIWindow?,
        rootViewController: UIViewController,
        animation: Animation? = nil
    ) {
        guard let snapshot = window?.snapshotView(afterScreenUpdates: true) else { return }
        rootViewController.view.addSubview(snapshot)
        window?.rootViewController = rootViewController

        UIView.animate(withDuration: 0.5, animations: {
            animation?(snapshot)
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }
}
