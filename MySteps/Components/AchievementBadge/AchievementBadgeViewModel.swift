//
//  AchievementBadgeViewModel.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 09.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

struct AchievementBadgeViewModel {
    let title: String
    let stepsCount: String
    let imageName: String

    init(steps: Int) {
        title = "achievement_cell.achievement_title".localized
        let rounded = Double(steps).roundToLowestValue(5000)
        let thousands = Int(rounded / 1000)
        stepsCount = "\(thousands.localized)K"
        imageName = "\(thousands)k"
    }
}
