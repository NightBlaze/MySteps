//
//  AchievementsTableViewCell.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {
    static let height: CGFloat = 224

    @IBOutlet weak var achievementsView: AchievementsView!

    func resolveDependencies(stepsReader: IStepsProviderReader,
                             animator: IAchievementAnimator) {
        achievementsView.resolveDependencies(stepsReader: stepsReader, animator: animator)
    }
}
