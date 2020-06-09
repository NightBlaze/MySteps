//
//  AchievementsViewInteractor.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAchievementsViewInteractor {
    func resolveDependencies(stepsReader: IStepsProviderReader)
    func loadData()
}

final class AchievementsViewInteractor {
    private let presenter: IAchievementsViewPresenter
    private var stepsReader: IStepsProviderReader?

    init(presenter: IAchievementsViewPresenter) {
        self.presenter = presenter

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(synchronizationFinished(notification:)),
                                               name: StepsSynchronizer.SynchronizationFinishedNotification,
                                               object: nil)
    }
}

// MARK: - IAchievementsViewInteractor

extension AchievementsViewInteractor: IAchievementsViewInteractor {
    func resolveDependencies(stepsReader: IStepsProviderReader) {
        self.stepsReader = stepsReader
    }

    func loadData() {
        stepsReader?.stepsForLastMonth() { [weak self] result in
            guard let self = self,
                case .success(let stepsResult) = result else { return }

            self.presenter.showAchievements(steps: stepsResult.steps)
        }
    }
}

// MARK: - Private

private extension AchievementsViewInteractor {
    @objc func synchronizationFinished(notification: NSNotification) {
        loadData()
    }
}
