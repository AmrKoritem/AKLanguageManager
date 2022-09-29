//
//  SecondViewController.swift
//  Example-Swift-AKLM
//
//  Created by Amr Koritem on 26/09/2022.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func changeSegmentImageDirection() {
        segmentedControl.revertImageHorizontalDirection(at: 1)
    }

    @IBAction func changeButtonImageDirection(_ sender: UIButton) {
        sender.revertImagesHorizontalDirection()
    }
}
