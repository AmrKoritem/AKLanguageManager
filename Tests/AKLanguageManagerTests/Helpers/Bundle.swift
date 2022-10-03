//
//  Bundle.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 03/10/2022.
//

import Foundation

extension Bundle {
    // TODO: - To be fixed.
    // Used to run tests in swift package manager.
    static var test: Bundle? {
#if SPM
        Bundle.module
#else
        nil
#endif
    }
}
