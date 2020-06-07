//
//  ProvidersFactory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IProvidersFactory: IFactory {
    func userProviderReader() -> IUserProviderReader
    func stepsProviderReader() -> IStepsProviderReader
}

final class ProvidersFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IUserProviderReader.self) { [unowned self] _ in
            let userReader = self.mainFactory.dataLayerFactory().lpsUserReader()
            let userWriter = self.mainFactory.dataLayerFactory().lpsUserWriter()
            return UserProvider(userReader: userReader, userWriter: userWriter)
        }

        container.register(IStepsProviderReader.self) { [unowned self] _ in
            let lpsStepsReader = self.mainFactory.dataLayerFactory().lpsStepsReader()
            return StepsProvider(stepsReader: lpsStepsReader)
        }
    }
}

// MARK: - IProvidersFactory

extension ProvidersFactory: IProvidersFactory {
    func userProviderReader() -> IUserProviderReader {
        return container.resolve(IUserProviderReader.self)!
    }

    func stepsProviderReader() -> IStepsProviderReader {
        return container.resolve(IStepsProviderReader.self)!
    }
}
