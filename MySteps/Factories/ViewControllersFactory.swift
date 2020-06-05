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
    func appStartViewController() -> UIViewController
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
        // Hardcoded strings for a while. They will be replaced soon
        container.register(UIViewController.self, name: "AppStart") { _ in
            UIViewController()
        }

        container.register(UIViewController.self, name: "Home") { _ in
            UIViewController()
        }
    }
}

// MARK: - IViewControllersFactory

extension ViewControllersFactory: IViewControllersFactory {
    func appStartViewController() -> UIViewController {
        return container.resolve(UIViewController.self, name: "AppStart")!
    }

    func homeViewController() -> UIViewController {
        return container.resolve(UIViewController.self, name: "Home")!
    }
}
