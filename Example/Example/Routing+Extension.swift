//
//  Routing+Extension.swift
//  Example
//
//  Created by Amr Koritem on 26/12/2021.
//  Copyright © 2021 Amr Koritem. All rights reserved.
//

import UIKit

/// Add the exact names of all storyboards in the project as cases in this enum
enum Storyboard: String {
    case LaunchScreen
    case Main

    var instance: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: Bundle.main)
    }

    var initialViewController: UIViewController? {
        instance.instantiateInitialViewController()
    }

    /// The storyboard id of this view controller in its storyboard must be exactly as the view controller class name, else it won't work.
    func instantiate<T: UIViewController>(viewController: T.Type) -> T {
        instance.instantiateViewController(withIdentifier: T.storyboardId) as? T ?? T()
    }
}

extension UIViewController {
    /// The storyboard id of this view controller in its storyboard must be exactly as the view controller class name, else it won't work.
    class var storyboardId: String {
        String(describing: self)
    }
}
