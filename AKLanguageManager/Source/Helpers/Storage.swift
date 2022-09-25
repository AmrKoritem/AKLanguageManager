//
//  Storage.swift
//  AKLanguageManager
//
//  Created by Amr Koritem on 13/09/2022.
//

import Foundation

protocol UserDefaultsProtocol {
    func string(forKey defaultName: String) -> String?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

protocol StorageProtocol {
    func string(forKey key: Language.Keys) -> String?
    func set(_ value: String?, forKey key: Language.Keys)
}

class Storage: StorageProtocol {
    static let shared = Storage()

    var userDefaults: UserDefaultsProtocol = UserDefaults.standard

    private init() {}

    func string(forKey key: Language.Keys) -> String? {
        userDefaults.string(forKey: key.rawValue)
    }

    func set(_ value: String?, forKey key: Language.Keys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}

/// Storage keys extension
extension Language {
    enum Keys: String {
        case selectedLanguage = "AKLanguageManager.selectedLanguage"
        case defaultLanguage = "AKLanguageManager.defaultLanguage"
    }
}
