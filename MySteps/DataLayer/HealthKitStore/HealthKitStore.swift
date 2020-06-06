//
//  HealthKitStore.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import HealthKit

protocol IHealthKitStore: IHealthKitStoreInitializer {
}

protocol IHealthKitStoreInitializer {
    func initializeHKS(_ completion: @escaping (Result<Void, Error>) -> Void)
}

final class HealthKitStore: IHealthKitStore {
    enum Errors: Error {
        case healthKitDataNotAvailable
        case initializationError
    }

    let healthKitStore = HKHealthStore()
}

// MARK: - IHealthKitStoreInitializer

extension HealthKitStore: IHealthKitStoreInitializer {
    func initializeHKS(_ completion: @escaping (Result<Void, Error>) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(Errors.healthKitDataNotAvailable))
            return
        }

        guard let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            completion(.failure(Errors.initializationError))
            return
        }

        healthKitStore.requestAuthorization(toShare: nil, read: [stepsCount]) { (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if !success {
                    completion(.failure(Errors.initializationError))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
