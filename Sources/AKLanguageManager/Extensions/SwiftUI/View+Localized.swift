//
//  View+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 08/10/2022.
//

import SwiftUI

public extension View {
    func localized(in language: Language = AKLanguageManager.shared.selectedLanguage) -> some View {
        environment(\.locale, language.get.locale)
            .environment(\.layoutDirection, language.get.layoutDirection)
            .id(UUID().uuidString)
    }
}
