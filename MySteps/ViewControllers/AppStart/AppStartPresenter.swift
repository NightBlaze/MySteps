//
//  AppStartPresenter.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAppStartPresenter {
    
}

final class AppStartPresenter {
    private weak var viewController: IAppStartViewController?
    
    func resolveDependencies(viewController: IAppStartViewController) {
        self.viewController = viewController
    }
}

// MARK: - IAppStartPresenter

extension AppStartPresenter: IAppStartPresenter {
}

// MARK: - Private

private extension AppStartPresenter {
}
