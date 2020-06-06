//
//  AppStartPresenter.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAppStartPresenter {
    func appInitializationSuccess()
    func appInitializationError(_ error: Error)
}

final class AppStartPresenter {
    private weak var viewController: IAppStartViewController?
    
    func resolveDependencies(viewController: IAppStartViewController) {
        self.viewController = viewController
    }
}

// MARK: - IAppStartPresenter

extension AppStartPresenter: IAppStartPresenter {
    func appInitializationSuccess() {
        viewController?.goToHomeScreen()
    }

    func appInitializationError(_ error: Error) {
        // TODO: Localize
        let errorViewModel = AppStartErrorViewModel(title: "Warning", message: "Cannot initialize application. Please try to reinstall it.")
        viewController?.showError(viewModel: errorViewModel)
    }
}

// MARK: - Private

private extension AppStartPresenter {
}
