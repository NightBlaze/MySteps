//
//  StepsProvider.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IStepsProviderReader {
    func steps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void)
}

final class StepsProvider {
    private let stepsReader: ILPSStepsReader

    init(stepsReader: ILPSStepsReader) {
        self.stepsReader = stepsReader
    }
}

// MARK: - IStepsProviderReader

extension StepsProvider: IStepsProviderReader {
    func steps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void) {
        stepsReader.fetchSteps(startDate: startDate, endDate: endDate, completion)
    }
}
