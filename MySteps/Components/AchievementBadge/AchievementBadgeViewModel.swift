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
    let subtitle: String
    let imageName: String

    static func noAchievements() -> AchievementBadgeViewModel {
        return AchievementBadgeViewModel(title: "achievement_badge.no_achievements_title".localized,
                                         subtitle: "achievement_badge.no_achievements_subtitle".localized,
                                         imageName: "no-steps")
    }

    private init(title: String, subtitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }

    init(steps: Int) {
        title = "achievement_badge.achievement_title".localized
        let rounded = Double(steps).roundToLowestValue(5000)
        let thousands = Int(rounded / 1000)
        subtitle = "\(thousands.localized)K"
        imageName = "\(thousands)k"
    }
}
