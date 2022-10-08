//
//  View+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 08/10/2022.
//

import SwiftUI

public extension View {
    func localized() -> some View {
        let defaultLanguage = AKLanguageManager.shared.defaultLanguage
        return environment(\.locale, AKLanguageManager.shared.observedLocalizer?.locale ?? defaultLanguage.locale)
            .environment(\.layoutDirection, AKLanguageManager.shared.observedLocalizer?.layoutDirection ?? defaultLanguage.layoutDirection)
            .id(AKLanguageManager.shared.observedLocalizer?.uuid ?? "")
    }
}
