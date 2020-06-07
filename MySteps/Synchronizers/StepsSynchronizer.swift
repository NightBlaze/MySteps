//
//  StepsSynchronizer.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IStepsSynchronizer {
    func startSynchronization()
}

/// StepsSynchronizer gets steps count from external resources
/// and saves it to local store.
final class StepsSynchronizer {
    // It's better to create seprate "SettingsStore"
    // and use it in this class as den dependency.
    // I use UserDefaults just to simplify this test assessment
    private static let lastSynchronizationDateKey = "lastSynchronizationDateKey"

    private let stepsReader: IHealthKitStoreStepsReader
    private let stepsWriter: ILPSStepsWriter
    private let localStore = UserDefaults.standard

    init(stepsReader: IHealthKitStoreStepsReader,
         stepsWriter: ILPSStepsWriter) {
        self.stepsReader = stepsReader
        self.stepsWriter = stepsWriter
    }
}

// MARK: - IStepsSynchronizer

extension StepsSynchronizer: IStepsSynchronizer {
    func startSynchronization() {
        // 1. Synchronize immediately
        synchronize()

        // 2. Subsribe to notifications
        // Synchronize steps on app launch
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
}

// MARK: - Private

private extension StepsSynchronizer {
    func synchronize() {
        // 1. Get last synchronization date
        // In any case synchronize tomorrow and today
        var startDate = lastSynchronizationDate()
        if startDate.timeIntervalSince1970 > Date.startOfYesterday.timeIntervalSince1970 {
            startDate = Date.startOfYesterday
        }
        let endDate = Date.endOfToday

        // 2. Get steps from external resource - HealthKit
        stepsReader.steps(startDate: startDate, endDate: endDate) { [weak self] result in
            guard case .success(let steps) = result, let self = self else { return }

            // 3. Save steps to local store
            self.stepsWriter.writeSteps(steps)

            // 4. Save last synchronization date
            self.saveLastSynchronizationDate(endDate)
        }
    }

    func lastSynchronizationDate() -> Date {
        let defaultDate = Date.startOfPreviousMonth
        return localStore.get(key: StepsSynchronizer.lastSynchronizationDateKey) ?? defaultDate
    }

    func saveLastSynchronizationDate(_ date: Date) {
        localStore.set(value: date, key: StepsSynchronizer.lastSynchronizationDateKey)
    }

    @objc func applicationDidBecomeActive(notification: NSNotification) {
        synchronize()
    }
}
