//
//  UserDAO+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import CoreStore

extension UserDAO {
    class func create(firstName: String,
                      lastName: String,
                      avatar: String,
                      transaction: AsynchronousDataTransaction) -> UserDAO {
        let user = transaction.create(Into<UserDAO>())
        user.id = UUID()
        user.firstName = firstName
        user.lastName = lastName
        user.avatar = avatar
        return user
    }
}
