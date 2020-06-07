//
//  LPSSteps.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import CoreStore

protocol ILPSStepsReader {
    func fetchSteps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void)
}

protocol ILPSStepsWriter {
    func writeSteps(_ dailySteps: [DailySteps])
}

final class LPSSteps {
    private let lps: ILocalPersistentStore
    private var dataStack: DataStack { lps.dataStack }

    init(lps: ILocalPersistentStore) {
        self.lps = lps
    }
}

// MARK: - ILPSStepsReader

extension LPSSteps: ILPSStepsReader {
    func fetchSteps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void) {
        do {
            let steps = try dataStack.fetchAll(
                From<StepsDAO>()
                    .where(\.date >= startDate && \.date <= endDate)
                    .orderBy(.ascending(\.date))
            )
            completion(.success(steps))
        } catch let error {
            completion(.failure(error))
        }
    }
}

// MARK: - ILPSStepsWriter

extension LPSSteps: ILPSStepsWriter {
    func writeSteps(_ dailySteps: [DailySteps]) {
        dataStack.perform(
            asynchronous: { (transaction) -> Void in
                dailySteps.forEach { dailyStep in
                    do {
                        var steps = try transaction.fetchOne(
                            From<StepsDAO>().where(\.date == dailyStep.date)
                        )
                        if steps == nil {
                            steps = transaction.create(Into<StepsDAO>())
                            steps?.date = dailyStep.date
                        }
                        steps?.count = Int32(dailyStep.steps)
                    } catch {}
                }

            },
            completion: { _ in }
        )
    }
}
