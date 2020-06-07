//
//  SynchronizersFactory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol ISynchronizersFactory: IFactory {
    func stepsSynchronizer() -> IStepsSynchronizer
}

final class SynchronizersFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IStepsSynchronizer.self) { [unowned self] _ in
            let stepsReader = self.mainFactory.dataLayerFactory().healthKitStoreStepsReader()
            let stepsWriter = self.mainFactory.dataLayerFactory().lpsStepsWriter()
            return StepsSynchronizer(stepsReader: stepsReader, stepsWriter: stepsWriter)
        }
    }
}

// MARK: - ISynchronizersFactory

extension SynchronizersFactory: ISynchronizersFactory {
    func stepsSynchronizer() -> IStepsSynchronizer {
        return container.resolve(IStepsSynchronizer.self)!
    }
}
