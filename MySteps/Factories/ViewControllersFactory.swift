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
    func homeViewController() -> UIViewController
}

final class ViewControllersFactory: IFactory {
    private let container: Container
    private let mainFactory: IMainFactory

    init(container: Container, mainFactory: IMainFactory) {
        self.container = container
        self.mainFactory = mainFactory
    }

    func register() {
        container.register(IAppStartViewController.self) { _ in
            let presenter = AppStartPresenter()
            let interactor = AppStartInteractor(presenter: presenter)
            let viewController = AppStartViewController(interactor: interactor)
            presenter.resolveDependencies(viewController: viewController)

            return viewController
        }

        container.register(UIViewController.self, name: "Home") { _ in
            UIViewController()
        }
    }
}

// MARK: - IViewControllersFactory

extension ViewControllersFactory: IViewControllersFactory {
    func appStartViewController() -> IAppStartViewController {
        return container.resolve(IAppStartViewController.self)!
    }

    func homeViewController() -> UIViewController {
        return container.resolve(UIViewController.self, name: "Home")!
    }
}
