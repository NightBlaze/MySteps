//
//  UIViewController+Window.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UIViewController {
    func setAsRootWindow(for: UIWindow? = nil) {
        var window = `for`
        if window == nil {
            window = UIApplication.shared.windows.filter { !$0.isHidden }.first
        }
        window?.rootViewController = self
        window?.makeKeyAndVisible()
    }
}
