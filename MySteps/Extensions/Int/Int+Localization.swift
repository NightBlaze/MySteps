//
//  Int+Localization.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension Int {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator ?? "."
        return formatter
    }()

    var localized: String {
        return Int.formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
