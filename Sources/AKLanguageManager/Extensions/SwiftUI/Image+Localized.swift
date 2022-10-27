//
//  Image+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 08/10/2022.
//

import SwiftUI

public extension Image {
    func directionLocalized(in language: Language = AKLanguageManager.shared.selectedLanguage) -> some View {
        flipsForRightToLeftLayoutDirection(language.get.isRightToLeft)
    }
}
