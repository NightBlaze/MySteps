//
//  UserBarViewModel.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

struct UserBarViewModel {
    let fullName: String

    init(dao: UserDAO) {
        fullName = ((dao.firstName ?? "") + " " + (dao.lastName ?? "")).trimmingCharacters(in: .whitespaces)
    }
}
