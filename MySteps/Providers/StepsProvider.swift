//
//  StepsProvider.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IStepsProviderReader {
    func stepsForLastMonth(_ completion: @escaping (Result<StepsProviderResult, Error>) -> Void)
}

struct StepsProviderResult {
    let startDate: Date
    let endDate: Date
    let steps: [StepsDAO]
}

final class StepsProvider {
    private let stepsReader: ILPSStepsReader

    init(stepsReader: ILPSStepsReader) {
        self.stepsReader = stepsReader
    }
}

// MARK: - IStepsProviderReader

extension StepsProvider: IStepsProviderReader {
    func stepsForLastMonth(_ completion: @escaping (Result<StepsProviderResult, Error>) -> Void) {
        let startDate = Date.previousMonth
        let endDate = Date.today
        stepsReader.fetchSteps(startDate: startDate, endDate: endDate) { result in
            switch result {
            case .success(let daos):
                completion(.success(StepsProviderResult(startDate: startDate, endDate: endDate, steps: daos)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
