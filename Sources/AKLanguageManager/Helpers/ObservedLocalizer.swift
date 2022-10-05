//
//  ObservedLocalizer.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 04/10/2022.
//

import SwiftUI

public class ObservedLocalizer: ObservableObject {
    /// The language manager.
    var languageManager: AKLanguageManagerProtocol = AKLanguageManager.shared

    /// A unique id used to refresh the view.
    var uuid: String {
        UUID().uuidString
    }

    /// The layout direction of the selected language.
    public var layoutDirection: LayoutDirection {
        languageManager.selectedLanguage.layoutDirection
    }

    /// The selected language.
    public var selectedLanguage: Language {
        get {
            languageManager.selectedLanguage
        }
        set {
            guard languageManager.selectedLanguage != newValue else { return }
            languageManager.setLanguage(language: newValue)
            objectWillChange.send()
        }
    }

    internal init() {}
}
