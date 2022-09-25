//
//  SettingsViewController.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

class SettingsViewController: UIViewController {
    @IBOutlet weak var fixedImageView: UIImageView!
    // Change Language and set rootViewController to the initial view controller
    @IBAction func changeLanguage() {
        // Choosing a language
        let newLanguage = AKLanguageManager.shared.selectedLanguage == .en ? Language.ar : Language.en
        AKLanguageManager.shared.setLanguage(
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

    override func viewDidLoad() {
        super.viewDidLoad()
        fixedImageView.shouldLocalizeDirection = false
    }
}
