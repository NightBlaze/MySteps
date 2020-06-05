//
//  AppStartViewController.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IAppStartViewController: UIViewController {
    
}

final class AppStartViewController: UIViewController {
    private var interactor: IAppStartInteractor?
    
    init(interactor: IAppStartInteractor?) {
        self.interactor = interactor
        // The name of the class is hardcoded because I use custom template
        // to generate VIP module
        super.init(nibName: "AppStartViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - IAppStartViewController

extension AppStartViewController: IAppStartViewController {
}

// MARK: - Private

private extension AppStartViewController {
}

// MARK: - IBAction

private extension AppStartViewController {
}
