//
//  LocalizedView.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 05/10/2022.
//

import SwiftUI

public struct LocalizedView<Content: View>: View {
    @ObservedObject internal var localizer: ObservedLocalizer

    private let content: Content

    var languageManager: AKLanguageManagerProtocol = AKLanguageManager.shared

    /// - Parameters:
    ///   - defaultLanguage: The default language when the app starts for the first time.
    ///   - content: Your app view.
    public init(_ defaultLanguage: Language, content: () -> Content) {
        let observedLocalizer = languageManager.observedLocalizer ?? ObservedLocalizer()
        languageManager.configureWith(defaultLanguage: defaultLanguage, observedLocalizer: observedLocalizer)
        self.content = content()
        self.localizer = observedLocalizer
    }

    public var body: some View {
        content
            .localized()
            .environmentObject(localizer)
    }
}
