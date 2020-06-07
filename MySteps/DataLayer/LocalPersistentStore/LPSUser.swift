//
//  LPSUser.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import CoreStore

protocol ILPSUserReader {
    func fetchUser(_ completion: @escaping (Result<UserDAO?, Error>) -> Void)
}

protocol ILPSUserWriter {
    func createFakeUser(_ completion: @escaping (Result<UserDAO, Error>) -> Void)
}

enum LPSUserErrors: Error {
    case createdUserIsNil
}

final class LPSUser {
    private let lps: ILocalPersistentStore
    private var dataStack: DataStack { lps.dataStack }

    init(lps: ILocalPersistentStore) {
        self.lps = lps
    }
}

// MARK: - ILPSUserReader

extension LPSUser: ILPSUserReader {
    func fetchUser(_ completion: @escaping (Result<UserDAO?, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            do {
                let user = try self?.dataStack.fetchOne(From<UserDAO>())
                completion(.success(user))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - ILPSUserWriter

extension LPSUser: ILPSUserWriter {
    func createFakeUser(_ completion: @escaping (Result<UserDAO, Error>) -> Void) {
        dataStack.perform(
            asynchronous: { transaction -> UserDAO in
                UserDAO.create(firstName: "Neil",
                               lastName: "Armstrong",
                               avatar: "profile-photo",
                               transaction: transaction)
            },
            success: { transactionUser in
                if let user = self.dataStack.fetchExisting(transactionUser) {
                    completion(.success(user))
                } else {
                    completion(.failure(LPSUserErrors.createdUserIsNil))
                }
            },
            failure: { error in
                completion(.failure(error))
            }
        )
    }
}
