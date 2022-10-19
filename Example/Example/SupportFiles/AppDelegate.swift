//
//  AppDelegate.swift
//  Example
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AKLanguageManager.shared.configureWith(defaultLanguage: .en)
        return true
    }
}

