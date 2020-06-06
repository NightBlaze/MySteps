//
//  AppStartViewController.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAppStartViewController: UIViewController {
    func goToHomeScreen()
    func showError(viewModel: AppStartErrorViewModel)
}

final class AppStartViewController: UIViewController {
    private let interactor: IAppStartInteractor
    private let router: IAppStartRouterScenario
    
    init(interactor: IAppStartInteractor,
         router: IAppStartRouterScenario) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interactor.initializeApp()
    }
}

// MARK: - IAppStartViewController

extension AppStartViewController: IAppStartViewController {
    func goToHomeScreen() {
        router.goToHome()
    }

    func showError(viewModel: AppStartErrorViewModel) {
        showSimpleAlert(title: viewModel.title, message: viewModel.message)
    }
}

// MARK: - Private

private extension AppStartViewController {
}

// MARK: - IBAction

private extension AppStartViewController {
}
