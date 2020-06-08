//
//  AchievementAnimator.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAchievementAnimator {
    func animate(view: UIView, indexPath: IndexPath)
}

final class AchievementAnimator {
}

// MARK: - IAchievementAnimator

extension AchievementAnimator: IAchievementAnimator {
    func animate(view: UIView, indexPath: IndexPath) {
        let duration = 0.8
        view.alpha = 0
        UIView.animate(withDuration: duration) {
            view.alpha = 1
        }

        let originalY = view.frame.origin.y
        let delay = 0.1 * Double(indexPath.row)
        view.frame.origin = CGPoint(x: view.frame.origin.x, y: view.frame.size.height)
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        view.frame.origin = CGPoint(x: view.frame.origin.x, y: originalY)
        }, completion: { _ in })
    }
}
