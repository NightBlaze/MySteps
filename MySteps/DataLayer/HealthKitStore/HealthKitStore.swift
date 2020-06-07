//
//  HealthKitStore.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import HealthKit

struct DailySteps {
    let date: Date
    let steps: UInt

    init(statistics: HKStatistics) {
        date = statistics.startDate
        var steps: UInt = 0
        if let quantity = statistics.sumQuantity() {
            steps = UInt(quantity.doubleValue(for: HKUnit.count()))
        }
        self.steps = steps
    }
}

protocol IHealthKitStoreInitializer {
    func initializeHKS(_ completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IHealthKitStoreStepsReader {
    func steps(startDate: Date, endDate: Date, completion: @escaping (Result<[DailySteps], Error>) -> Void)
}

final class HealthKitStore {
    enum Errors: Error {
        case healthKitDataNotAvailable
        case initializationError
        case stepsReaderNoResults
    }

    private let healthKitStore = HKHealthStore()

    // The type of data we are requesting in IHealthKitStoreStepsReader
    private let stepsType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    private let stepsReaderInterval: DateComponents = {
        var interval = DateComponents()
        interval.day = 1
        return interval
    }()
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

                self.steps(startDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, endDate: Date()) { result in

                }
            }
        }
    }
}

// MARK: - IHealthKitStoreStepsReader

extension HealthKitStore: IHealthKitStoreStepsReader {

    // from https://stackoverflow.com/a/44982915/13612799
    func steps(startDate: Date, endDate: Date, completion: @escaping (Result<[DailySteps], Error>) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())

        let query = HKStatisticsCollectionQuery(quantityType: stepsType,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startDate,
                                                intervalComponents: stepsReaderInterval)

        query.initialResultsHandler = { _, results, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let myResults = results {
                var dailySteps = [DailySteps]()
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    dailySteps.append(DailySteps(statistics: statistics))
                }
                DispatchQueue.main.async {
                    completion(.success(dailySteps))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(Errors.stepsReaderNoResults))
                }
            }

        }

        healthKitStore.execute(query)
    }
}
