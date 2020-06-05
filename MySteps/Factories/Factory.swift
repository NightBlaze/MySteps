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
    func viewControllersFactory() -> IViewControllersFactory
}

final class Factory: IFactory {
    private let container = Container()

    func register() {
        container.register(IViewControllersFactory.self) { [unowned self] _ in
            ViewControllersFactory(container: self.container, mainFactory: self)
        }.inObjectScope(.container)

        registerOther()
    }

    private func registerOther() {
        viewControllersFactory().register()
    }
}

// MARK: - IMainFactory

extension Factory: IMainFactory {
    func viewControllersFactory() -> IViewControllersFactory {
        return container.resolve(IViewControllersFactory.self)!
    }
}
