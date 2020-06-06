//
//  String+Localization.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

// from https://gist.github.com/Juanpe/0ba09355229c0afa2ced6609735fd46c
// How to use
// "hello".localized
// "hello %@! you are %d years old".localized(args: ["Mike", 25])
// "hello %@! you are %d years old".localized("Mike", 25)
extension String {
    var localized: String {
        NSLocalizedString(self, comment: "\(self)_comment")
    }

    func localized(args: [CVarArg]) -> String {
        localized(args)
    }

    func localized(_ args: CVarArg...) -> String {
        String(format: localized, args)
    }
}

