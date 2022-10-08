//
//  ObservedLocalizer.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 04/10/2022.
//

import SwiftUI

public final class ObservedLocalizer: ObservableObject {
    /// The language manager.
    weak var languageManager = AKLanguageManager.shared

    /// The layout direction of the selected language.
    public var layoutDirection: LayoutDirection {
        selectedLanguage.layoutDirection
    }

    /// The locale of the selected language.
    public var locale: Locale {
        selectedLanguage.locale
    }

    /// The direction of the selected language.
    public var isRightToLeft: Bool {
        selectedLanguage.isRightToLeft
    }

    /// The selected language.
    public var selectedLanguage: Language {
        get {
            languageManager?.selectedLanguage ?? languageManager?.deviceLanguage ?? .en
        }
        set {
            guard languageManager?.selectedLanguage != newValue else { return }
            languageManager?.setLanguage(language: newValue)
            objectWillChange.send()
        }
    }

    internal init() {}
}
