//
//  LocalPersistentStore.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import CoreData

protocol ILocalPersistentStore: ILocalPersistentStoreInitializer {
}

protocol ILocalPersistentStoreInitializer {
    func initializeLPS(_ completion: @escaping (Result<Void, Error>) -> Void)
}

final class LocalPersistentStore: ILocalPersistentStore {
    enum Errors: Error {
        case errorInitializeCoreData
    }

    private static let containerName = "MySteps"
    private static let sqliteName = containerName + ".sqlite"
}

// MARK: - ILocalPersistentStoreInitializer

extension LocalPersistentStore: ILocalPersistentStoreInitializer {
    func initializeLPS(_ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
