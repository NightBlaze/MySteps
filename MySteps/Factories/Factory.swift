//
//  Factory.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 05.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation
import Swinject

protocol IFactory {
    func register()
}

protocol IMainFactory: IFactory {
}

final class Factory: IFactory {
    private let container = Container()

    func register() {
        registerOther()
    }

    private func registerOther() {
    }
}

// MARK: - IMainFactory

extension Factory: IMainFactory {
}
