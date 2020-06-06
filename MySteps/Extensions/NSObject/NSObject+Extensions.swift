//
//  NSObject+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension NSObject {
    class func nameOfClass() -> String {
        guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {
            assertionFailure("Can't get class name because it doesn't contait '.' in the name")
            return "UnknownClass"
        }

        return name
    }

    func nameOfClass() -> String {
        return String(describing: type(of: self))
    }
}
