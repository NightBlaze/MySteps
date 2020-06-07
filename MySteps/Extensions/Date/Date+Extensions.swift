//
//  Date+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import AFDateHelper

extension Date {
    var startOfMonth: Date {
        self.dateFor(.startOfMonth)
    }

    var endOfMonth: Date {
        self.dateFor(.endOfMonth).adjust(hour: 23, minute: 59, second: 59)
    }

    static var startOfPreviousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date())!.adjust(hour: 0, minute: 0, second: 0, day: 0)
    }

    static var endOfToday: Date {
        Date().dateFor(.endOfDay)
    }

    static var startOfYesterday: Date {
        Date().dateFor(.yesterday).adjust(hour: 0, minute: 0, second: 0)
    }
}
