//
//  MockUserDefaults.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 21/09/2022.
//

import Foundation
@testable import AKLanguageManager

class MockUserDefaults: UserDefaultsProtocol {
    private var savedData: [String: Any?] = [:]

    func string(forKey defaultName: String) -> String? {
        savedData[defaultName] as? String
    }

    func set(_ value: Any?, forKey defaultName: String) {
        savedData[defaultName] = value
    }
}
