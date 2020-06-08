//
//  AnimatorsFactory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IAnimatorsFactory: IFactory {
    func achievementAnimator() -> IAchievementAnimator
}

final class AnimatorsFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IAchievementAnimator.self) { _ in
            AchievementAnimator()
        }
    }
}

// MARK: - IAnimatorsFactory

extension AnimatorsFactory: IAnimatorsFactory {
    func achievementAnimator() -> IAchievementAnimator {
        return container.resolve(IAchievementAnimator.self)!
    }
}
