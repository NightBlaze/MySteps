//
//  FileManager+Extensions.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 10.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import Foundation

extension FileManager {
    static func cachesDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
