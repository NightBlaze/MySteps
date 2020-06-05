//
//  HomePresenter.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

protocol IHomePresenter {
    
}

final class HomePresenter {
    private weak var viewController: IHomeViewController?
    
    func resolveDependencies(viewController: IHomeViewController) {
        self.viewController = viewController
    }
}

// MARK: - IHomePresenter

extension HomePresenter: IHomePresenter {
}

// MARK: - Private

private extension HomePresenter {
}
