//
//  ChartViewModel.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

struct ChartViewModel {
    let startDate: Date
    let endDate: Date
    let stepsPerDay: [Date: UInt]
    var totalSteps: UInt {
        stepsPerDay.reduce(0) { (sum, steps) -> UInt in
            let (_, value) = steps
            return sum + value
        }
    }

    init(startDate: Date, endDate: Date, daos: [StepsDAO]) {
        self.startDate = startDate
        self.endDate = endDate
        var steps = [Date: UInt]()
        for dao in daos {
            if let date = dao.date {
                steps[date] = UInt(dao.count)
            }
        }
        stepsPerDay = steps
    }
}
