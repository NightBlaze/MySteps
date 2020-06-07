//
//  AppStartInteractor.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAppStartInteractor {
    func initializeApp()
}

final class AppStartInteractor {
    private let presenter: IAppStartPresenter
    private let healthKitStore: IHealthKitStoreInitializer
    private let localPersistentStore: ILocalPersistentStoreInitializer
    private let stepsSynchronizer: IStepsSynchronizer
    
    init(presenter: IAppStartPresenter,
         healthKitStore: IHealthKitStoreInitializer,
         localPersistentStore: ILocalPersistentStoreInitializer,
         stepsSynchronizer: IStepsSynchronizer) {
        self.presenter = presenter
        self.healthKitStore = healthKitStore
        self.localPersistentStore = localPersistentStore
        self.stepsSynchronizer = stepsSynchronizer
    }
}

// MARK: - IAppStartInteractor

extension AppStartInteractor: IAppStartInteractor {
    func initializeApp() {
        // Because we have only two core subsystems
        // here we can use "stair" syntax.
        // In case if we'll have more core subsystems
        // it's better to use "plain" syntax and use
        // disptach group for grouping of initialization
        self.initializeLPS { [weak self] result in
            guard let self = self else { return }
            if case .failure(let error) = result {
                self.presenter.errorInitializeLocalPersistentStore(error)
                return
            }

            // We can start steps synchronization only after LPS initialization
            self.stepsSynchronizer.startSynchronization()
            // App delegate should holds StepsSynchronizer
            (UIApplication.shared.delegate as! AppDelegate).stepsSynchronizer = self.stepsSynchronizer

            self.initializeHealthKit { result in
                if case .failure(let error) = result {
                    self.presenter.errorInitializeHealthKitStore(error)
                } else {
                    self.presenter.appInitializationSuccess()
                }
            }
        }
    }
}

// MARK: - Private

private extension AppStartInteractor {
    func initializeLPS(_ completion: @escaping (Result<Void, Error>) -> Void) {
        localPersistentStore.initializeLPS(completion)
    }

    func initializeHealthKit(_ completion: @escaping (Result<Void, Error>) -> Void) {
        healthKitStore.initializeHKS(completion)
    }
}
