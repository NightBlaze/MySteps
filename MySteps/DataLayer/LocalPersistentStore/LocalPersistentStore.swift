//
//  LocalPersistentStore.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import CoreStore

protocol ILocalPersistentStore: ILocalPersistentStoreInitializer {
    var dataStack: DataStack { get }
}

protocol ILocalPersistentStoreInitializer {
    func initializeLPS(_ completion: @escaping (Result<Void, Error>) -> Void)
}

final class LocalPersistentStore: ILocalPersistentStore {
    private static let modelName = "MySteps"
    private static let sqliteFileName = modelName + ".sqlite"

    lazy var dataStack = DataStack(xcodeModelName: LocalPersistentStore.modelName)
}

// MARK: - ILocalPersistentStoreInitializer

extension LocalPersistentStore: ILocalPersistentStoreInitializer {
    func initializeLPS(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let _ = dataStack.addStorage(
        SQLiteStore(
            fileName: LocalPersistentStore.sqliteFileName,
            localStorageOptions: .recreateStoreOnModelMismatch // Only for development! Never use in production!
            )
        ) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
