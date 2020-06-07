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
    func healthKitStoreStepsReader() -> IHealthKitStoreStepsReader
    func localPersistentStoreInitializer() -> ILocalPersistentStoreInitializer
    func lpsUserReader() -> ILPSUserReader
    func lpsUserWriter() -> ILPSUserWriter
    func lpsStepsReader() -> ILPSStepsReader
    func lpsStepsWriter() -> ILPSStepsWriter
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
        }

        container.register(IHealthKitStoreStepsReader.self) { _ in
            HealthKitStore()
        }

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

        container.register(ILPSStepsReader.self) { [unowned self] _ in
            let lps = self.localPersistentStore()
            return LPSSteps(lps: lps)
        }

        container.register(ILPSStepsWriter.self) { [unowned self] _ in
            let lps = self.localPersistentStore()
            return LPSSteps(lps: lps)
        }
    }
}

// MARK: - IDataLayerFactory

extension DataLayerFactory: IDataLayerFactory {
    func healthKitStoreInitializer() -> IHealthKitStoreInitializer {
        return container.resolve(IHealthKitStoreInitializer.self)!
    }

    func healthKitStoreStepsReader() -> IHealthKitStoreStepsReader {
        return container.resolve(IHealthKitStoreStepsReader.self)!
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

    func lpsStepsReader() -> ILPSStepsReader {
        return container.resolve(ILPSStepsReader.self)!
    }

    func lpsStepsWriter() -> ILPSStepsWriter {
        return container.resolve(ILPSStepsWriter.self)!
    }
}

// MARK: - Private

private extension DataLayerFactory {
    func localPersistentStore() -> ILocalPersistentStore {
        return container.resolve(ILocalPersistentStore.self)!
    }
}
