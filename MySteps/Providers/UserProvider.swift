//
//  UserProvider.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IUserProviderReader {
    func loggedInUser(_ completion: @escaping (Result<UserDAO, Error>) -> Void)
}

enum UserProviderReaderErrors: Error {
    case errorFetchLoggedInUser
}

final class UserProvider {
    private let userReader: ILPSUserReader
    private let userWriter: ILPSUserWriter

    init(userReader: ILPSUserReader,
         userWriter: ILPSUserWriter) {
        self.userReader = userReader
        self.userWriter = userWriter
    }
}

// MARK: - IUserProviderReader

extension UserProvider: IUserProviderReader {
    func loggedInUser(_ completion: @escaping (Result<UserDAO, Error>) -> Void) {

        let handle: (UserDAO?) -> Bool = { user -> Bool in
            if let user = user {
                completion(.success(user))
                return true
            }
            return false
        }


        let queue = DispatchQueue(label: "com.ati-soft.UserProvider.IUserProviderReader")
        queue.async { [weak self] in
            guard let self = self else { return }

            let group = DispatchGroup()
            var user: UserDAO?

            // 1. Try to fetch user in local store
            group.enter()
            self.fetchUser { fetchedUser in
                user = fetchedUser
                group.leave()
            }
            group.wait()

            // 2. If user exists then return
            if handle(user) {
                return
            }

            // 3. User not found
            // Trying to create fake user
            self.createUser { createdUser in
                user = createdUser
            }

            // 4. Error creating fake user
            if !handle(user) {
                completion(.failure(UserProviderReaderErrors.errorFetchLoggedInUser))
            }
        }
    }
}

// MARK: - Private

private extension UserProvider {
    func fetchUser(_ completion: @escaping (UserDAO?) -> Void) {
        userReader.fetchUser { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(_):
                completion(nil)
            }
        }
    }

    func createUser(_ completion: @escaping (UserDAO?) -> Void) {
        userWriter.createFakeUser { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
