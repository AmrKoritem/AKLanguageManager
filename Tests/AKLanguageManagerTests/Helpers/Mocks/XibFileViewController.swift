//
//  XibFileViewController.swift
//  AKLanguageManagerTests
//
//  Created by Amr Koritem on 18/09/2022.
//

import UIKit
import AKLanguageManager

// Xib file is in Resources file.
class XibFileViewController: UIViewController {
    @IBOutlet weak var explicitLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        explicitLabel.text = "translate".localized
    }
}
