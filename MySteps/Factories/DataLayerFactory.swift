//
//  DataLayerFactory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IDataLayerFactory: IFactory {
    func healthKitStoreInitializer() -> IHealthKitStoreInitializer
    func localPersistentStoreInitializer() -> ILocalPersistentStoreInitializer
    func lpsUserReader() -> ILPSUserReader
    func lpsUserWriter() -> ILPSUserWriter
}

final class DataLayerFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IHealthKitStoreInitializer.self) { _ in
            HealthKitStore()
        }.inObjectScope(.container)

        container.register(ILocalPersistentStore.self) { _ in
            LocalPersistentStore()
        }.inObjectScope(.container)

        container.register(ILPSUserReader.self) { [unowned self] _ in
            let lps = self.localPersistentStore()
            return LPSUser(lps: lps)
        }

        container.register(ILPSUserWriter.self) { [unowned self] _ in
            let lps = self.localPersistentStore()
            return LPSUser(lps: lps)
        }
    }
}

// MARK: - IDataLayerFactory

extension DataLayerFactory: IDataLayerFactory {
    func healthKitStoreInitializer() -> IHealthKitStoreInitializer {
        return healthKitStore() as IHealthKitStoreInitializer
    }

    func localPersistentStoreInitializer() -> ILocalPersistentStoreInitializer {
        return localPersistentStore() as ILocalPersistentStoreInitializer
    }

    func lpsUserReader() -> ILPSUserReader {
        return container.resolve(ILPSUserReader.self)!
    }

    func lpsUserWriter() -> ILPSUserWriter {
        return container.resolve(ILPSUserWriter.self)!
    }
}

// MARK: - Private

private extension DataLayerFactory {
    func healthKitStore() -> IHealthKitStoreInitializer {
        return container.resolve(IHealthKitStoreInitializer.self)!
    }

    func localPersistentStore() -> ILocalPersistentStore {
        return container.resolve(ILocalPersistentStore.self)!
    }
}
