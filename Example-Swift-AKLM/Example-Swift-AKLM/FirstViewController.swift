//
//  FirstViewController.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKLanguageManager

class FirstViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    // Changing the language from another screen.
    @IBAction func goToSettings() {
        let settingsVC = Storyboard.Main.instantiate(viewController: SettingsViewController.self)
        show(settingsVC, sender: self)
    }

    // Change the image direction while the selected language doesn't change.
    @IBAction func switchImageDirection() {
        imageView.revertImageHorizontalDirection()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main".localized
    }
}

