//
//  Image+Localized.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 08/10/2022.
//

import SwiftUI

public extension Image {
    func directionLocalized() -> some View {
        flipsForRightToLeftLayoutDirection(AKLanguageManager.shared.observedLocalizer?.isRightToLeft ?? false)
    }
}
