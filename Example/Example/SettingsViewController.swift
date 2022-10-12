//
//  SettingsViewController.swift
//  Example
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

class SettingsViewController: UIViewController {
    @IBOutlet weak var fixedImageView: UIImageView!
    // Change Language and set rootViewController to the initial view controller
    @IBAction func changeLanguage() {
        // Swap between anglish and arabic languages
        let newLanguage = AKLanguageManager.shared.selectedLanguage == .en ? Language.ar : Language.en
        AKLanguageManager.shared.setLanguage(
            language: newLanguage,
            viewControllerFactory: { _ in
                // The view controller that you want to show after changing the language
                let settingsVC = Storyboard.Main.instantiate(viewController: SettingsViewController.self)
                return Storyboard.Main.initialViewController ?? settingsVC
            },
            animation: { view in
                // Do custom animation
                view.alpha = 0
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the image direction fixed even when localization direction change
        fixedImageView.shouldLocalizeDirection = false
    }
}
