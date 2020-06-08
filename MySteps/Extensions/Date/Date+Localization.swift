//
//  Date+Localization.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension Date {
    private static let formatterWithYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        let localFormatter = DateFormatter.dateFormat(fromTemplate: "MMM d YYYY", options: 0, locale: NSLocale.current)
        dateFormatter.dateFormat = localFormatter
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    private static let formatterWithoutYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        let localFormatter = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: NSLocale.current)
        dateFormatter.dateFormat = localFormatter
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()

    func localized(withYear: Bool) -> String {
        let dateFormatter = withYear ? Date.formatterWithYear : Date.formatterWithoutYear
        return dateFormatter.string(from: self).replacingOccurrences(of: ",", with: "")
    }
}
