//
//  UIViewController+alert.swift
//  DeedADay
//
//  Created by RJ Smithers on 4/21/20.
//  Copyright © 2020 RJ Smithers. All rights reserved.
//

import UIKit

extension UIViewController {
    func oneButton(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
