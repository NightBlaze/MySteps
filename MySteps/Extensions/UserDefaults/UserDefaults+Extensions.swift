//
//  UserDefaults+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension UserDefaults {
    func get<T>(key: String, default: T? = nil) -> T? {
        if let result = UserDefaults.standard.value(forKey: key) as? T {
            return result
        }

        return `default`
    }

    func set(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
