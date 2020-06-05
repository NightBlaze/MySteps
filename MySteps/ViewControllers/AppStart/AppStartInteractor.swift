//
//  AppStartInteractor.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAppStartInteractor {
    
}

final class AppStartInteractor {
    private var presenter: IAppStartPresenter
    
    init(presenter: IAppStartPresenter) {
        self.presenter = presenter
    }
}

// MARK: - IAppStartInteractor

extension AppStartInteractor: IAppStartInteractor {
}

// MARK: - Private

private extension AppStartInteractor {
}
