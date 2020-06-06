//
//  UIViewController+Alert.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "ok".localized, style: .default)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }
}
