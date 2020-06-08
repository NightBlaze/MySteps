//
//  Colors.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 08.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

struct Colors {
    private static let defaultBackground: UIColor = .black
    private static let defaultWhite: UIColor = .white

    struct Background {
        static let viewController = Colors.defaultBackground
        static let view = Colors.defaultBackground
        static let tableViewCell = Colors.defaultBackground
        static let collectionViewCell = Colors.defaultBackground
        static let label = Colors.defaultBackground
        static let imageView = Colors.defaultBackground
    }

    struct Foreground {
        static let white = Colors.defaultWhite
        static let grey = UIColor(white: 1.0, alpha: 0.5)
        static let lightGrey = UIColor(white: 1.0, alpha: 0.2)
        static let green = UIColor(red: 134.0 / 255.0, green: 198.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
        static let blue = UIColor(red: 25.0 / 255.0, green: 150.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }

    struct Graph {
        static let green = UIColor(red: 173.0 / 255.0, green: 228.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        static let blue = UIColor(red: 28.0 / 255.0, green: 126.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
}
