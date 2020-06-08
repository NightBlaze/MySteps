//
//  AchievementsViewPresenter.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAchievementsViewPresenter {
    func showAchievements(steps: [StepsDAO])
}

final class AchievementsViewPresenter {
    private weak var view: IAchievementsViewUpdater?

    func resolveDependencies(view: IAchievementsViewUpdater) {
        self.view = view
    }
}

// MARK: - IAchievementsViewPresenter

extension AchievementsViewPresenter: IAchievementsViewPresenter {
    func showAchievements(steps: [StepsDAO]) {
        let viewModels = createViewModels(daos: steps)
        view?.updateViewModels(viewModels)
    }
}

// MARK: - Private

private extension AchievementsViewPresenter {
    func createViewModels(daos: [StepsDAO]) -> [AchievementCellViewModel] {
        var totalSteps = Int(daos.reduce(0) { $0 + $1.count })
        if totalSteps > 40000 {
            totalSteps = 40000
        }
        return checkStepsAndReturnAchievements(acc: [], steps: totalSteps, decreaseStep: 5000).reversed()
    }

    func checkStepsAndReturnAchievements(acc: [AchievementCellViewModel], steps: Int, decreaseStep: Int) -> [AchievementCellViewModel] {
        if steps < 10000 {
            return acc
        }

        let achievement = AchievementCellViewModel(steps: steps)
        var result = acc
        result.append(achievement)

        return checkStepsAndReturnAchievements(acc: result, steps: steps - decreaseStep, decreaseStep: decreaseStep)
    }
}
