//
//  Factory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IFactory {
    func register()
}

protocol IMainFactory: IFactory {
    func animatorsFactory() -> IAnimatorsFactory
    func dataLayerFactory() -> IDataLayerFactory
    func providersFactory() -> IProvidersFactory
    func routerFactory() -> IRouterFactory
    func synchronizersFactory() -> ISynchronizersFactory
    func viewControllersFactory() -> IViewControllersFactory
}

final class Factory: IFactory {
    private let container = Container()

    func register() {
        container.register(IAnimatorsFactory.self) { [unowned self] _ in
            AnimatorsFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        container.register(IDataLayerFactory.self) { [unowned self] _ in
            DataLayerFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        container.register(IProvidersFactory.self) { [unowned self] _ in
            ProvidersFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        container.register(IRouterFactory.self) { [unowned self] _ in
            RouterFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        container.register(ISynchronizersFactory.self) { [unowned self] _ in
            SynchronizersFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        container.register(IViewControllersFactory.self) { [unowned self] _ in
            ViewControllersFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        registerOther()
    }

    private func registerOther() {
        animatorsFactory().register()
        dataLayerFactory().register()
        providersFactory().register()
        routerFactory().register()
        synchronizersFactory().register()
        viewControllersFactory().register()
    }
}

// MARK: - IMainFactory

extension Factory: IMainFactory {
    func animatorsFactory() -> IAnimatorsFactory {
        return container.resolve(IAnimatorsFactory.self)!
    }

    func dataLayerFactory() -> IDataLayerFactory {
        return container.resolve(IDataLayerFactory.self)!
    }

    func providersFactory() -> IProvidersFactory {
        return container.resolve(IProvidersFactory.self)!
    }

    func routerFactory() -> IRouterFactory {
        return container.resolve(IRouterFactory.self)!
    }

    func synchronizersFactory() -> ISynchronizersFactory {
        return container.resolve(ISynchronizersFactory.self)!
    }

    func viewControllersFactory() -> IViewControllersFactory {
        return container.resolve(IViewControllersFactory.self)!
    }
}
