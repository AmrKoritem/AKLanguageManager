//
//  SettingsViewController.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

class SettingsViewController: UIViewController {
    // Change Language and set rootViewController to the initial view controller
    @IBAction func changeLanguage() {
        // Choosing a language
        let newLanguage = LanguageManager.shared.currentLanguage == .en ? Languages.ar : Languages.en
        LanguageManager.shared.setLanguage(
            language: newLanguage,
            viewControllerFactory: { [unowned self] _ in
                // The view controller that you want to show after changing the language
                let viewController = self.storyboard?.instantiateInitialViewController()
                return viewController ?? self
            },
            animation: { view in
                // Do custom animation
                view.alpha = 0
            }
        )
    }
}
