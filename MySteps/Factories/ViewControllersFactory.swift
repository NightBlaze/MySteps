//
//  ViewControllersFactory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IViewControllersFactory: IFactory {
    func appStartViewController() -> IAppStartViewController
    func homeViewController() -> IHomeViewController
}

final class ViewControllersFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IAppStartViewController.self) { [unowned self] _ in
            let presenter = AppStartPresenter()
            let healthKit = self.mainFactory.dataLayerFactory().healthKitStoreInitializer()
            let localPersistentStore = self.mainFactory.dataLayerFactory().localPersistentStoreInitializer()
            let interactor = AppStartInteractor(presenter: presenter,
                                                healthKitStore: healthKit,
                                                localPersistentStore: localPersistentStore)
            let router = self.mainFactory.routerFactory().appStartRouterScenario()
            let viewController = AppStartViewController(interactor: interactor, router: router)
            presenter.resolveDependencies(viewController: viewController)

            return viewController
        }

        container.register(IHomeViewController.self) { _ in
            let presenter = HomePresenter()
            let interactor = HomeInteractor(presenter: presenter)
            let viewController = HomeViewController(interactor: interactor)
            presenter.resolveDependencies(viewController: viewController)

            return viewController
        }
    }
}

// MARK: - IViewControllersFactory

extension ViewControllersFactory: IViewControllersFactory {
    func appStartViewController() -> IAppStartViewController {
        return container.resolve(IAppStartViewController.self)!
    }

    func homeViewController() -> IHomeViewController {
        return container.resolve(IHomeViewController.self)!
    }
}
