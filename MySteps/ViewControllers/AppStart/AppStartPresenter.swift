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
    func errorInitializeLocalPersistentStore(_ error: Error)
    func errorInitializeHealthKitStore(_ error: Error)
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
    
    func errorInitializeLocalPersistentStore(_ error: Error) {
        let errorViewModel = AppStartErrorViewModel(title: "warning".localized,
                                                    message: "app_start_view_controller.app_initialization.error".localized)
        viewController?.showError(viewModel: errorViewModel)
    }

    func errorInitializeHealthKitStore(_ error: Error) {
        let errorViewModel = AppStartErrorViewModel(title: "warning".localized,
                                                    message: "app_start_view_controller.healthkit_initialization.error".localized)
        viewController?.showError(viewModel: errorViewModel)
    }
}

// MARK: - Private

private extension AppStartPresenter {
}
