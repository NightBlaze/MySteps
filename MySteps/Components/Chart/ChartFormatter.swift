//
//  ChartFormatter.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Charts

final class ChartFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let x = Int(value)
        if x == 1 {
            return "1"
        } else if x % 5 == 0 {
            return "\(x)"
        }
        return ""
    }
}
