//
//  AchievementViewModel.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

struct AchievementViewModel {
    let title: String
    let stepsCount: String
    let imageName: String

    init(steps: Int) {
        // TODO: localize
        title = "Goal\nachievement"
        let rounded = Double(steps).roundToLowestValue(5000)
        let thousands = Int(rounded / 1000)
        stepsCount = "\(thousands)K"
        imageName = "\(thousands)k"
    }
}
