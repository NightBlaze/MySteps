//
//  UIView+UILayer.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 10.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

extension UIView {
    func makeRound() {
        guard self.bounds.size.width > 2 else { return }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.width / 2
    }
}
