//
//  HealthKitStore.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IHealthKitStore: IHealthKitStoreInitializer {
}

protocol IHealthKitStoreInitializer {
    func initializeHKS(_ completion: @escaping (Result<Void, Error>) -> Void)
}

final class HealthKitStore: IHealthKitStore {
    enum Errors: Error {
        case errorInitializeHealthKit
    }
}

// MARK: - IHealthKitStoreInitializer

extension HealthKitStore: IHealthKitStoreInitializer {
    func initializeHKS(_ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
