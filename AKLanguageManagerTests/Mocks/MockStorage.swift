//
//  MockStorage.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 18/09/2022.
//

import Foundation
@testable import AKLanguageManager

class MockStorage: StorageProtocol {
    private(set) var selectedLanguage: String?
    private(set) var defaultLanguage: String?

    func string(forKey key: Language.Keys) -> String? {
        switch key {
        case .selectedLanguage: return selectedLanguage
        case .defaultLanguage: return defaultLanguage
        }
    }

    func set(_ value: String?, forKey key: Language.Keys) {
        switch key {
        case .selectedLanguage: selectedLanguage = value
        case .defaultLanguage: defaultLanguage = value
        }
    }
}
