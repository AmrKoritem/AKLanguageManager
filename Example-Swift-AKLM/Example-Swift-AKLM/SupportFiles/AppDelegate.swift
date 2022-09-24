//
//  AppDelegate.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AKLanguageManager.shared.defaultLanguage = .en
        return true
    }
}

