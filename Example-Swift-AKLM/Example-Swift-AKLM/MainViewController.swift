//
//  MainViewController.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

class MainViewController: UIViewController {
    // Changing the language from another screen.
    @IBAction func goToSettings() {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") else { return }
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    // Change Language and set rootViewController to settings view controller
    @IBAction func changeLanguage() {
        // Choosing a language
        let newLanguage = AKLanguageManager.shared.selectedLanguage == .en ? Languages.ar : Languages.en
        AKLanguageManager.shared.setLanguage(
            language: newLanguage,
            viewControllerFactory: { [unowned self] _ in
                // The view controller that you want to show after changing the language
                let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
                return settingsVC ?? self
            },
            animation: { view in
                // Do custom animation
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main".localized
    }
}

