//
//  Storage.swift
//
//  Created by Amr Koritem on 8/27/22.
//

import Foundation

protocol StorageProtocol {
    func string(forKey key: Languages.Keys) -> String?
    func set(_ value: String, forKey: Languages.Keys)
}

class Storage: StorageProtocol {
    static let shared = Storage()

    private init() {}

    func string(forKey key: Languages.Keys) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }

    func set(_ value: String, forKey: Languages.Keys) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
}

/// Storage keys extension
extension Languages {
    enum Keys: String {
        case selectedLanguage = "AKLanguageManager.selectedLanguage"
        case defaultLanguage = "AKLanguageManager.defaultLanguage"
    }
}
