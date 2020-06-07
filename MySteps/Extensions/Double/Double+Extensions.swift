//
//  Double+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension Double {
    // from https://stackoverflow.com/a/37998886
    func roundToLowestValue(_ value: Double) -> Double {
        let multiple = floor(self / value)
        let returnValue = value * multiple
        return returnValue
    }
}
