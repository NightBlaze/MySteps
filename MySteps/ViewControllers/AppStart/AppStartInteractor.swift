//
//  AppStartInteractor.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IAppStartInteractor {
    func initializeApp()
}

final class AppStartInteractor {
    private var presenter: IAppStartPresenter
    
    init(presenter: IAppStartPresenter) {
        self.presenter = presenter
    }
}

// MARK: - IAppStartInteractor

extension AppStartInteractor: IAppStartInteractor {
    func initializeApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.presenter.appInitializationSuccess()
        }
    }
}

// MARK: - Private

private extension AppStartInteractor {
}
