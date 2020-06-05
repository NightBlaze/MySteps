//
//  HomeViewController.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IHomeViewController: UIViewController {
    
}

final class HomeViewController: UIViewController {
    private var interactor: IHomeInteractor?
    
    init(interactor: IHomeInteractor?) {
        self.interactor = interactor
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - IHomeViewController

extension HomeViewController: IHomeViewController {
}

// MARK: - Private

private extension HomeViewController {
}

// MARK: - IBAction

private extension HomeViewController {
}
