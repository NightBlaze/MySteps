//
//  Router.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IRouter: IAppStartRouterScenario {
}

protocol IAppStartRouterScenario {
    func goToHome()
}

/// Very simple Router. Because this test assignment has only one screen the Router
/// implements only one scenario: switching to home screen after the app start.
/// Basically, the Router will implement different routing scenarios.
final class Router: IRouter {
    private let viewControllersFactory: IViewControllersFactory

    init(viewControllersFactory: IViewControllersFactory) {
        self.viewControllersFactory = viewControllersFactory
    }
}

// MARK: - IAppStartRouterScenario

extension Router: IAppStartRouterScenario {
    func goToHome() {
        let homeViewController = viewControllersFactory.homeViewController()
        setRootViewController(viewController: homeViewController)
    }
}

// MARK: - Private

private extension Router {
    func setRootViewController(viewController: UIViewController, forWindow: UIWindow? = nil) {
        viewController.setAsRootWindow(for: forWindow)
    }
}
