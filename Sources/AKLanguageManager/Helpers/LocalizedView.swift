//
//  LocalizedView.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 05/10/2022.
//

import SwiftUI

public struct LocalizedView<Content: View>: View {
    @ObservedObject
    var languageManager = AKLanguageManager.shared

    private let content: Content

    /// - Parameters:
    ///   - defaultLanguage: The default language when the app starts for the first time.
    ///   - content: Your app view.
    public init(_ defaultLanguage: Language?, content: () -> Content) {
        self.content = content()
        languageManager.defaultLanguage = defaultLanguage ?? LanguageWrapper.deviceLanguage
    }

    public var body: some View {
        content
            .localized()
            .environmentObject(languageManager)
    }
}
