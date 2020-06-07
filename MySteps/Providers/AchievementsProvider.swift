//
//  AchievementsProvider.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAchievementsProviderReader {
    func steps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void)
}

final class AchievementsProvider {
    private let stepsReader: ILPSStepsReader

    init(stepsReader: ILPSStepsReader) {
        self.stepsReader = stepsReader
    }
}

// MARK: - IAchievementsProviderReader

extension AchievementsProvider: IAchievementsProviderReader {
    func steps(startDate: Date, endDate: Date, _ completion: @escaping (Result<[StepsDAO], Error>) -> Void) {
        stepsReader.fetchSteps(startDate: startDate, endDate: endDate, completion)
    }
}
